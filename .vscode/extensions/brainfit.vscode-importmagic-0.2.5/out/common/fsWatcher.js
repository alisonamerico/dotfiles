"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
class FileSystemWatcher {
    constructor(languageId, listener) {
        this.languageId = languageId;
        this.listener = listener;
        this.changedFiles = new Set();
        this.timeout = null;
        // createFileSystemWatcher has problems with Windows 7, so
        vscode.workspace.onDidSaveTextDocument(this.onChangeProjectFile.bind(this));
    }
    onChangeProjectFile(doc) {
        if (doc.languageId !== this.languageId) {
            return;
        }
        this.changedFiles.add(doc.fileName);
        if (this.timeout !== null) {
            clearTimeout(this.timeout);
        }
        this.timeout = setTimeout(() => {
            this.listener(this.changedFiles);
            this.changedFiles = new Set();
        }, 2000);
    }
}
exports.FileSystemWatcher = FileSystemWatcher;
//# sourceMappingURL=fsWatcher.js.map