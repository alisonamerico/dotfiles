"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const events_1 = require("events");
const systemVariables_1 = require("./systemVariables");
const utils_1 = require("./utils");
const child_process = require("child_process");
const path = require("path");
const vscode = require("vscode");
const untildify = require("untildify");
exports.IS_WINDOWS = /^win/.test(process.platform);
class ExtensionSettings extends events_1.EventEmitter {
    constructor(workspaceFolder) {
        super();
        this.extraPaths = [];
        this.multiline = null;
        this.maxColumns = null;
        this.indentWithTabs = null;
        this.skipTestFolders = true;
        this.disposables = [];
        this.workspaceRoot = workspaceFolder ? workspaceFolder : vscode.Uri.file(__dirname);
        this.disposables.push(vscode.workspace.onDidChangeConfiguration(() => {
            this.initializeSettings();
            this.emit('change');
        }));
        this.initializeSettings();
    }
    static getInstance(resource) {
        const workspaceFolderUri = ExtensionSettings.getSettingsUri(resource);
        const workspaceFolderKey = workspaceFolderUri ? workspaceFolderUri.fsPath : '';
        if (!ExtensionSettings.instances.has(workspaceFolderKey)) {
            const settings = new ExtensionSettings(workspaceFolderUri);
            ExtensionSettings.instances.set(workspaceFolderKey, settings);
        }
        return ExtensionSettings.instances.get(workspaceFolderKey);
    }
    static getSettingsUri(resource) {
        const workspaceFolder = resource ? vscode.workspace.getWorkspaceFolder(resource) : undefined;
        let workspaceFolderUri = workspaceFolder ? workspaceFolder.uri : undefined;
        if (!workspaceFolderUri && Array.isArray(vscode.workspace.workspaceFolders) && vscode.workspace.workspaceFolders.length > 0) {
            workspaceFolderUri = vscode.workspace.workspaceFolders[0].uri;
        }
        return workspaceFolderUri;
    }
    static dispose() {
        if (!utils_1.isTestExecution()) {
            throw new Error('Dispose can only be called from unit tests');
        }
        ExtensionSettings.instances.forEach(item => item.dispose());
        ExtensionSettings.instances.clear();
    }
    dispose() {
        this.disposables.forEach(disposable => disposable.dispose());
        this.disposables = [];
    }
    initializeSettings() {
        const workspaceRoot = this.workspaceRoot.fsPath;
        const systemVariables = new systemVariables_1.SystemVariables(this.workspaceRoot ? this.workspaceRoot.fsPath : undefined);
        const pythonSettings = vscode.workspace.getConfiguration('python', this.workspaceRoot);
        const pluginSettings = vscode.workspace.getConfiguration('importMagic', this.workspaceRoot);
        const editorSettings = vscode.workspace.getConfiguration('editor', this.workspaceRoot);
        this.pythonPath = systemVariables.resolveAny(pythonSettings.get('pythonPath'));
        this.pythonPath = getAbsolutePath(this.pythonPath, workspaceRoot);
        let extraPaths = systemVariables.resolveAny(pythonSettings.get('autoComplete.extraPaths'));
        this.extraPaths = [];
        for (let path of Array.isArray(extraPaths) ? extraPaths : [extraPaths]) {
            this.extraPaths.push(getAbsolutePath(path, workspaceRoot));
        }
        this.multiline = pluginSettings.get('multiline');
        this.maxColumns = pluginSettings.get('maxColumns');
        this.indentWithTabs = pluginSettings.get('indentWithTabs');
        this.skipTestFolders = pluginSettings.get('skipTestFolders');
        if (!this.maxColumns) {
            const rulers = editorSettings.get('rulers', []);
            if (rulers.length > 0 && rulers[0] > 39) {
                this.maxColumns = rulers[0];
            }
        }
    }
    get pythonPath() {
        return this._pythonPath;
    }
    set pythonPath(value) {
        if (this._pythonPath === value) {
            return;
        }
        // Add support for specifying just the directory where the python executable will be located.
        // E.g. virtual directory name.
        try {
            this._pythonPath = getPythonExecutable(value);
        }
        catch (ex) {
            this._pythonPath = value;
        }
    }
    get style() {
        const obj = {};
        if (this.multiline !== null) {
            obj.multiline = this.multiline;
        }
        if (this.maxColumns !== null) {
            obj.maxColumns = this.maxColumns;
        }
        if (this.indentWithTabs !== null) {
            obj.indentWithTabs = this.indentWithTabs;
        }
        return obj;
    }
}
ExtensionSettings.instances = new Map();
exports.ExtensionSettings = ExtensionSettings;
function getAbsolutePath(pathToCheck, rootDir) {
    pathToCheck = untildify(pathToCheck);
    if (utils_1.isTestExecution() && !pathToCheck) {
        return rootDir;
    }
    return path.isAbsolute(pathToCheck) ? pathToCheck : path.resolve(rootDir, pathToCheck);
}
function getPythonExecutable(pythonPath) {
    pythonPath = untildify(pythonPath);
    // If only 'python'.
    if (pythonPath === 'python' ||
        pythonPath.indexOf(path.sep) === -1 ||
        path.basename(pythonPath) === path.dirname(pythonPath)) {
        return pythonPath;
    }
    if (isValidPythonPath(pythonPath)) {
        return pythonPath;
    }
    // Keep python right on top, for backwards compatibility.
    const KnownPythonExecutables = ['python', 'python4', 'python3.8', 'python3.7', 'python3.6', 'python3.5', 'python3'];
    for (let executableName of KnownPythonExecutables) {
        // Suffix with 'python' for linux and 'osx', and 'python.exe' for 'windows'.
        if (exports.IS_WINDOWS) {
            executableName = `${executableName}.exe`;
            if (isValidPythonPath(path.join(pythonPath, executableName))) {
                return path.join(pythonPath, executableName);
            }
            if (isValidPythonPath(path.join(pythonPath, 'scripts', executableName))) {
                return path.join(pythonPath, 'scripts', executableName);
            }
        }
        else {
            if (isValidPythonPath(path.join(pythonPath, executableName))) {
                return path.join(pythonPath, executableName);
            }
            if (isValidPythonPath(path.join(pythonPath, 'bin', executableName))) {
                return path.join(pythonPath, 'bin', executableName);
            }
        }
    }
    return pythonPath;
}
function isValidPythonPath(pythonPath) {
    try {
        const output = child_process.execFileSync(pythonPath, ['-c', 'print(1234)'], { encoding: 'utf8' });
        return output.startsWith('1234');
    }
    catch (ex) {
        return false;
    }
}
//# sourceMappingURL=configSettings.js.map