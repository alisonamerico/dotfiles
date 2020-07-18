"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
class Progress {
    constructor() {
        this.progress = null;
        this.cancellationFlag = null;
    }
    setTitle(message) {
        if (this.progress === null) {
            vscode.window.withProgress({
                location: vscode.ProgressLocation.Notification,
                title: 'ImportMagic'
            }, (progress) => {
                this.progress = progress;
                this.progress.report({ message });
                return new Promise((resolve) => {
                    this.cancellationFlag = resolve;
                });
            });
        }
        else {
            this.progress.report({ message });
        }
    }
    hide() {
        if (this.cancellationFlag !== null) {
            this.cancellationFlag();
            this.progress = null;
        }
    }
}
exports.Progress = Progress;
//# sourceMappingURL=progress.js.map