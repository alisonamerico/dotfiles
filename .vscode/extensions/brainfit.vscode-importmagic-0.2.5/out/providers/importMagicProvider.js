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
const fs = require("fs-extra");
const vscode_1 = require("vscode");
const importMagicProxy_1 = require("./importMagicProxy");
const utils_1 = require("../common/utils");
class ImportMagicProvider {
    constructor(importMagicFactory) {
        this.importMagicFactory = importMagicFactory;
    }
    getImportSuggestions(sourceFile, unresolvedName) {
        return __awaiter(this, void 0, void 0, function* () {
            const activeEditor = vscode_1.window.activeTextEditor;
            if (!activeEditor) {
                return [];
            }
            const importMagic = this.importMagicFactory.getImportMagicProxy(activeEditor.document.uri);
            if (!importMagic) {
                return [];
            }
            const cmd = {
                action: importMagicProxy_1.ActionType.Suggestions,
                sourceFile,
                unresolvedName
            };
            try {
                const result = yield importMagic.sendCommand(cmd);
                return result.items.map(suggestion => {
                    return {
                        label: suggestion.module ? `from ${suggestion.module} import ${suggestion.symbol}` : `import ${suggestion.symbol}`,
                        description: '',
                        module: suggestion.module,
                        symbol: suggestion.symbol
                    };
                });
            }
            catch (e) {
                vscode_1.window.showErrorMessage(`Importmagic: ${e.message}`);
                return undefined;
            }
        });
    }
    resolveImport() {
        return __awaiter(this, void 0, void 0, function* () {
            const activeEditor = vscode_1.window.activeTextEditor;
            if (!activeEditor) {
                return undefined;
            }
            const document = activeEditor.document;
            if (!activeEditor || document.languageId !== 'python') {
                vscode_1.window.showErrorMessage('Importmagic: Please, open a Python source file to show import suggestions');
                return undefined;
            }
            // Get current selected name
            const position = activeEditor.selection.start;
            const range = document.getWordRangeAtPosition(position);
            if (!range || range.isEmpty) {
                vscode_1.window.showErrorMessage('Importmagic: Empty resolve expression');
                return undefined;
            }
            const unresolvedName = document.getText(range);
            if (!unresolvedName || unresolvedName.length < 2) {
                vscode_1.window.showErrorMessage('Importmagic: Empty or very short expression for resolve');
                return undefined;
            }
            const tmpFileCreated = document.isDirty;
            const filePath = tmpFileCreated ? yield utils_1.getTempFileWithDocumentContents(document) : document.fileName;
            const cToken = new vscode_1.CancellationTokenSource();
            try {
                const quickPickOptions = {
                    matchOnDetail: true,
                    matchOnDescription: true,
                    placeHolder: `Import statement for ${unresolvedName}`
                };
                const suggestions = this.getImportSuggestions(filePath, unresolvedName);
                suggestions.then((results) => {
                    if (results.length === 0) {
                        vscode_1.window.showWarningMessage('Importmagic: Nothing to import');
                    }
                    if (results.length === 0 || results === undefined) {
                        cToken.cancel();
                    }
                });
                const selection = yield vscode_1.window.showQuickPick(suggestions, quickPickOptions, cToken.token);
                if (selection !== undefined) {
                    vscode_1.commands.executeCommand('importMagic.insertImport', selection.module, selection.symbol);
                }
            }
            finally {
                cToken.dispose();
                if (tmpFileCreated) {
                    fs.unlinkSync(filePath);
                }
            }
        });
    }
    insertImport(module, symbol) {
        return __awaiter(this, void 0, void 0, function* () {
            const activeEditor = vscode_1.window.activeTextEditor;
            if (!activeEditor) {
                return undefined;
            }
            const document = activeEditor.document;
            if (!activeEditor || document.languageId !== 'python') {
                vscode_1.window.showErrorMessage('Importmagic: Please, open a Python source file to show import suggestions');
                return undefined;
            }
            const importMagic = this.importMagicFactory.getImportMagicProxy(document.uri);
            if (!importMagic) {
                return undefined;
            }
            const tmpFileCreated = document.isDirty;
            const filePath = tmpFileCreated ? yield utils_1.getTempFileWithDocumentContents(document) : document.fileName;
            try {
                const cmd = {
                    action: importMagicProxy_1.ActionType.Import,
                    sourceFile: filePath,
                    module,
                    symbol
                };
                const result = yield importMagic.sendCommand(cmd);
                yield this.updateSource(document.uri, result);
            }
            catch (e) {
                vscode_1.window.showErrorMessage(`Importmagic: ${e.message}`);
            }
            finally {
                if (tmpFileCreated) {
                    fs.unlinkSync(filePath);
                }
            }
        });
    }
    rebuildIndex() {
        return __awaiter(this, void 0, void 0, function* () {
            const activeEditor = vscode_1.window.activeTextEditor;
            if (!activeEditor) {
                return undefined;
            }
            const importMagic = this.importMagicFactory.getImportMagicProxy(activeEditor.document.uri);
            if (!importMagic) {
                return undefined;
            }
            const cmd = {
                action: importMagicProxy_1.ActionType.Renew
            };
            yield importMagic.sendCommand(cmd);
        });
    }
    openDocument(doc) {
        this.importMagicFactory.getImportMagicProxy(doc.uri);
        // Do noting. Watcher will be initialized for document workspace
    }
    updateSource(fileUri, result) {
        return __awaiter(this, void 0, void 0, function* () {
            const changes = new vscode_1.WorkspaceEdit();
            result.commands.forEach(edit => {
                const start = new vscode_1.Position(edit.start, 0);
                const end = new vscode_1.Position(edit.end, 0);
                const range = new vscode_1.Range(start, end);
                switch (edit.action) {
                    case importMagicProxy_1.DiffAction.Replace:
                        changes.replace(fileUri, range, edit.text);
                        break;
                    case importMagicProxy_1.DiffAction.Insert:
                        changes.insert(fileUri, start, edit.text);
                        break;
                    case importMagicProxy_1.DiffAction.Delete:
                        changes.delete(fileUri, range);
                        break;
                    default:
                }
            });
            if (!changes || changes.entries().length === 0) {
                return;
            }
            yield vscode_1.workspace.applyEdit(changes);
        });
    }
}
exports.ImportMagicProvider = ImportMagicProvider;
//# sourceMappingURL=importMagicProvider.js.map