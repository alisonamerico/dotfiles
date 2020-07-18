"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
class Logger {
    constructor() {
        this.channel = vscode.window.createOutputChannel('vscode-importmagic');
    }
    dispose() {
        this.channel.dispose();
    }
    log(message) {
        this.channel.appendLine(getTimestamp() + ' ' + message);
    }
    logError(message) {
        this.channel.appendLine(getTimestamp() + ' ERR: ' + message);
    }
}
exports.Logger = Logger;
function getTimestamp() {
    const date = new Date();
    return '[' + date.toUTCString() + ']';
}
//# sourceMappingURL=logger.js.map