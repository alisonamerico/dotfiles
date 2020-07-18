"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
class ImportMagic {
    constructor(importMagicProvider) {
        this.importMagicProvider = importMagicProvider;
        this.disposables = [];
        const p = this.importMagicProvider;
        this.disposables.push(vscode_1.workspace.onDidOpenTextDocument(p.openDocument.bind(p)));
        this.disposables.push(vscode_1.commands.registerCommand('importMagic.resolveImport', p.resolveImport.bind(p)));
        this.disposables.push(vscode_1.commands.registerCommand('importMagic.insertImport', p.insertImport.bind(p)));
        this.disposables.push(vscode_1.commands.registerCommand('importMagic.rebuildIndex', p.rebuildIndex.bind(p)));
        // For opened documents init proxy
        for (const doc of vscode_1.workspace.textDocuments) {
            p.openDocument(doc);
        }
    }
    dispose() {
        this.disposables.forEach(disposable => disposable.dispose());
    }
}
exports.ImportMagic = ImportMagic;
//# sourceMappingURL=importMagic.js.map