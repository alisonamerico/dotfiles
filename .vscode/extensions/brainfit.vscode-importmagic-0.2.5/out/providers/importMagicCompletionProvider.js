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
const vscode = require("vscode");
const importMagicProxy_1 = require("./importMagicProxy");
class ImportMagicCompletionItemProvider {
    constructor(importMagicFactory) {
        this.importMagicFactory = importMagicFactory;
    }
    provideCompletionItems(document, position, token, context) {
        return __awaiter(this, void 0, void 0, function* () {
            const result = yield this.getCompletionResult(document, position, token);
            if (result === undefined) {
                return [];
            }
            return result;
        });
    }
    getCompletionResult(document, position, token) {
        return __awaiter(this, void 0, void 0, function* () {
            const range = document.getWordRangeAtPosition(position);
            const text = document.getText(range);
            if (!text || text.length < 2) {
                return undefined;
            }
            const importMagic = this.importMagicFactory.getImportMagicProxy(document.uri);
            if (!importMagic) {
                return undefined;
            }
            const cmd = {
                action: importMagicProxy_1.ActionType.Symbols,
                text
            };
            const result = yield importMagic.sendCommand(cmd);
            return result.items.map(item => this.toVsCodeCompletion(document, position, item));
        });
    }
    toVsCodeCompletion(document, position, item) {
        const completionItem = new vscode.CompletionItem(item.symbol || item.module);
        switch (item.kind) {
            case 'C':
                completionItem.kind = vscode.CompletionItemKind.Class;
                break;
            case 'R':
                completionItem.kind = vscode.CompletionItemKind.Reference;
                break;
            case 'F':
                completionItem.kind = vscode.CompletionItemKind.Function;
                break;
            case 'M':
                completionItem.kind = vscode.CompletionItemKind.Module;
                break;
            default:
                completionItem.kind = vscode.CompletionItemKind.Text;
        }
        completionItem.command = {
            command: 'importMagic.insertImport',
            title: 'Import Magic',
            arguments: [item.module, item.symbol]
        };
        completionItem.detail = item.module ? `from ${item.module} import ${item.symbol}` : `import ${item.symbol}`;
        if (item.kind === 'R') {
            // References should be below then the others
            completionItem.sortText = completionItem.label + 'z'.repeat(30);
            completionItem.filterText = 'z'.repeat(30) + completionItem.label;
        }
        return completionItem;
    }
}
exports.ImportMagicCompletionItemProvider = ImportMagicCompletionItemProvider;
//# sourceMappingURL=importMagicCompletionProvider.js.map