'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const importMagicCompletionProvider_1 = require("./providers/importMagicCompletionProvider");
const importMagicProvider_1 = require("./providers/importMagicProvider");
const importMagicProxyFactory_1 = require("./languageServices/importMagicProxyFactory");
const importMagic_1 = require("./importMagic");
const PYTHON = { scheme: 'file', language: 'python' };
function activate(context) {
    const importMagicFactory = new importMagicProxyFactory_1.ImportMagicProxyFactory(context.asAbsolutePath('.'), context.storagePath);
    const completionProvider = vscode.languages.registerCompletionItemProvider(PYTHON, new importMagicCompletionProvider_1.ImportMagicCompletionItemProvider(importMagicFactory), '.');
    const provider = new importMagicProvider_1.ImportMagicProvider(importMagicFactory);
    const app = new importMagic_1.ImportMagic(provider);
    context.subscriptions.push(completionProvider, app);
}
exports.activate = activate;
//# sourceMappingURL=extension.js.map