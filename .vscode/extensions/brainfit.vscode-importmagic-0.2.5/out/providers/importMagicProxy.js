"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const fsWatcher_1 = require("./../common/fsWatcher");
const configSettings_1 = require("./../common/configSettings");
const proc_1 = require("./../common/proc");
const path = require("path");
const vscode = require("vscode");
const helpers_1 = require("../common/helpers");
var DiffAction;
(function (DiffAction) {
    DiffAction["Delete"] = "delete";
    DiffAction["Insert"] = "insert";
    DiffAction["Replace"] = "replace";
})(DiffAction = exports.DiffAction || (exports.DiffAction = {}));
var ActionType;
(function (ActionType) {
    ActionType["Configure"] = "configure";
    ActionType["ChangeFiles"] = "changeFiles";
    ActionType["Renew"] = "rebuildIndex";
    ActionType["Suggestions"] = "importSuggestions";
    ActionType["Import"] = "insertImport";
    ActionType["Symbols"] = "getSymbols";
})(ActionType = exports.ActionType || (exports.ActionType = {}));
class ImportMagicProxy {
    constructor(extensionRootDir, workspacePath, storagePath, workspaceName, progress, logger) {
        this.extensionRootDir = extensionRootDir;
        this.workspacePath = workspacePath;
        this.storagePath = storagePath;
        this.workspaceName = workspaceName;
        this.progress = progress;
        this.logger = logger;
        this.previousData = '';
        this.commands = new Map();
        this.commandId = 0;
        this.restartAttempts = 0;
        this.stopReason = ''; // Bad startup configuration reason
        this.settings = configSettings_1.ExtensionSettings.getInstance(vscode.Uri.file(this.workspacePath));
        this.settings.on('change', this.onChangeSettings.bind(this));
        this.fsWatcher = new fsWatcher_1.FileSystemWatcher('python', this.onChangeProjectFiles.bind(this));
        this.restartServer();
    }
    static getProperty(o, name) {
        return o[name];
    }
    dispose() {
        this.killProcess();
    }
    sendCommand(cmd) {
        return __awaiter(this, void 0, void 0, function* () {
            yield this.processDeferred.promise;
            if (this.stopReason) {
                throw new Error(`Extenstion is not ready: ${this.stopReason}`);
            }
            // Await commands from queue
            while (this.commands.size > 0) {
                const firstCmd = this.commands.values().next().value;
                if (firstCmd === undefined) {
                    break;
                }
                yield firstCmd.deferred.promise;
            }
            return this.sendRequest(cmd);
        });
    }
    configure() {
        return __awaiter(this, void 0, void 0, function* () {
            const cmd = {
                action: ActionType.Configure,
                paths: this.settings.extraPaths,
                workspacePath: this.workspacePath,
                skipTest: this.settings.skipTestFolders,
                tempPath: this.storagePath,
                workspaceName: this.workspaceName,
                style: this.settings.style
            };
            // If configure was with error, then we will stop language server
            try {
                const result = yield this.sendRequest(cmd);
            }
            catch (e) {
                this.stopReason = e.message;
                vscode.window.showErrorMessage(`Importmagic: ${this.stopReason}`);
            }
        });
    }
    onChangeProjectFiles(files) {
        const cmd = {
            action: ActionType.ChangeFiles,
            files: Array.from(files)
        };
        this.sendRequest(cmd);
    }
    onChangeSettings() {
        // Restart language server because python path could be changed
        this.restartAttempts = 0;
        this.stopReason = '';
        this.restartServer();
    }
    restartServer() {
        this.processDeferred = helpers_1.createDeferred();
        this.killProcess();
        this.clearPendingRequests();
        this.spawnProcess();
    }
    spawnProcess() {
        return __awaiter(this, void 0, void 0, function* () {
            this.restartAttempts += 1;
            const cwd = path.join(this.extensionRootDir, 'pythonFiles');
            const pythonProcess = new proc_1.ProcessService();
            const pythonPath = this.settings.pythonPath;
            const args = ['-W', 'ignore', 'importMagic.py']; // Whoosh has brought us some warnings...
            const result = pythonProcess.execObservable(pythonPath, args, { cwd });
            this.proc = result.proc;
            if (!result.proc.pid) {
                this.processDeferred.reject();
                this.stopReason = 'Python interpreter is not found';
                vscode.window.showErrorMessage(`Importmagic: ${this.stopReason}`);
                return false;
            }
            result.proc.on('close', (end) => {
                this.logger.log(`spawnProcess.end: ${end}`);
                // this.proc = null;
                if (end === 101) {
                    this.stopReason = 'Python3 is required';
                    vscode.window.showErrorMessage(`Importmagic: ${this.stopReason}`);
                }
            });
            result.proc.on('error', error => {
                this.logger.logError(`${error}`);
            });
            result.out.subscribe(output => {
                const data = output.out;
                const dataStr = this.previousData = `${this.previousData}${data}`;
                if (dataStr.endsWith('\n')) {
                    this.previousData = '';
                    dataStr.split('\n').forEach(lineStr => this.onData(lineStr));
                }
            });
            yield this.configure();
            this.processDeferred.resolve();
        });
    }
    killProcess() {
        try {
            if (this.proc) {
                this.proc.kill();
            }
            // tslint:disable-next-line:no-empty
        }
        catch (_a) { }
        this.proc = null;
    }
    sendRequest(cmd) {
        this.commandId += 1;
        const extendedPayload = Object.assign({ requestId: this.commandId }, cmd);
        const executionCmd = cmd;
        executionCmd.deferred = helpers_1.createDeferred();
        executionCmd.commandId = this.commandId;
        try {
            if (!this.proc) {
                throw new Error('ImportMagic process is die');
            }
            this.logger.log(`cmd -> ${JSON.stringify(extendedPayload)}`);
            this.proc.stdin.write(`${JSON.stringify(extendedPayload)}\n`);
            this.commands.set(this.commandId, executionCmd);
        }
        catch (ex) {
            this.logger.logError(ex.message);
            if (this.restartAttempts < 10) {
                this.restartServer();
                return Promise.reject('ImportMagic process will be restarted. Try run command again');
            }
            else {
                return Promise.reject('ImportMagic can not start the process');
            }
        }
        return executionCmd.deferred.promise;
    }
    clearPendingRequests() {
        this.commands.forEach(item => {
            item.deferred.reject();
        });
        this.commands.clear();
    }
    onData(dataStr) {
        try {
            if (dataStr) {
                this.logger.log(`<- ${dataStr}`);
            }
            const response = JSON.parse(dataStr);
            const responseId = ImportMagicProxy.getProperty(response, 'id');
            const progressMessage = ImportMagicProxy.getProperty(response, 'progress');
            const isError = !!response.error;
            if (progressMessage) {
                // Only set progress
                this.progress.setTitle(progressMessage);
                return;
            }
            else {
                // Hide progress and parse the answer
                this.progress.hide();
            }
            // Somethimes error may happened just after startup
            if (isError) {
                this.logger.logError(response.message);
            }
            if (responseId === undefined) {
                this.logger.logError('Response is not contain id');
                return;
            }
            const cmd = this.commands.get(responseId);
            if (!cmd) {
                return;
            }
            this.commands.delete(responseId);
            const handler = isError ? this.onError : this.getCommandHandler(cmd.action);
            if (!handler) {
                return;
            }
            const result = handler.call(this, cmd, response);
            if (cmd && cmd.deferred) {
                if (isError) {
                    cmd.deferred.reject(result);
                }
                else {
                    cmd.deferred.resolve(result);
                }
            }
            // tslint:disable-next-line:no-empty
        }
        catch (_a) { }
    }
    getCommandHandler(command) {
        switch (command) {
            case ActionType.Configure:
                return this.onConfigure;
            case ActionType.ChangeFiles:
                return this.onChangeFiles;
            case ActionType.Renew:
                return this.onRenew;
            case ActionType.Suggestions:
                return this.onSymbols; // this.onSuggestions;
            case ActionType.Symbols:
                return this.onSymbols;
            case ActionType.Import:
                return this.onImport;
            default:
                return;
        }
    }
    onError(command, response) {
        return {
            requestId: command.commandId,
            error: true,
            message: ImportMagicProxy.getProperty(response, 'message'),
            traceback: ImportMagicProxy.getProperty(response, 'traceback'),
            type: ImportMagicProxy.getProperty(response, 'type')
        };
    }
    onConfigure(command, response) {
        return {
            requestId: command.commandId,
            success: ImportMagicProxy.getProperty(response, 'success')
        };
    }
    onChangeFiles(command, response) {
        return {
            requestId: command.commandId,
            success: ImportMagicProxy.getProperty(response, 'success')
        };
    }
    onRenew(command, response) {
        return {
            requestId: command.commandId,
            success: ImportMagicProxy.getProperty(response, 'success')
        };
    }
    onImport(command, response) {
        return {
            requestId: command.commandId,
            commands: ImportMagicProxy.getProperty(response, 'diff')
        };
    }
    onSymbols(command, response) {
        const items = ImportMagicProxy.getProperty(response, 'items');
        return {
            requestId: command.commandId,
            items
        };
    }
}
exports.ImportMagicProxy = ImportMagicProxy;
//# sourceMappingURL=importMagicProxy.js.map