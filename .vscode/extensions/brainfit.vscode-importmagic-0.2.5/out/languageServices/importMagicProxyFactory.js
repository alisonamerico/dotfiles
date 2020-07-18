"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const importMagicProxy_1 = require("../providers/importMagicProxy");
const progress_1 = require("./../common/progress");
const logger_1 = require("../common/logger");
class ImportMagicProxyFactory {
    constructor(extensionRootPath, storagePath) {
        this.extensionRootPath = extensionRootPath;
        this.storagePath = storagePath;
        this.progress = new progress_1.Progress();
        this.logger = new logger_1.Logger();
        this.disposables = [];
        this.proxyHandlers = new Map();
        this.logger.log('Starting vscode-importmagic...');
    }
    dispose() {
        this.disposables.forEach(disposable => disposable.dispose());
        this.disposables = [];
        this.proxyHandlers.clear();
    }
    getImportMagicProxy(resource) {
        const workspaceFolder = vscode_1.workspace.getWorkspaceFolder(resource);
        let workspacePath = workspaceFolder ? workspaceFolder.uri.fsPath : undefined;
        let workspaceName = workspaceFolder ? workspaceFolder.name : undefined;
        if (!workspacePath) {
            return;
        }
        let importMagic = this.proxyHandlers.get(workspacePath);
        if (!importMagic) {
            importMagic = new importMagicProxy_1.ImportMagicProxy(this.extensionRootPath, workspacePath, this.storagePath, workspaceName, this.progress, this.logger);
            this.disposables.push(importMagic);
            this.proxyHandlers.set(workspacePath, importMagic);
        }
        return importMagic;
    }
}
exports.ImportMagicProxyFactory = ImportMagicProxyFactory;
//# sourceMappingURL=importMagicProxyFactory.js.map