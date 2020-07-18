"use strict";
/*
 * progress.ts
 *
 * Copyright (c) Microsoft Corporation.
 * Licensed under the MIT license.
 *
 * Provides a way for the pyright language server to report progress
 * back to the client and display it in the editor.
 */
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProgressReporting = void 0;
const vscode_1 = require("vscode");
const AnalysisTimeoutInMs = 60000;
class ProgressReporting {
    constructor(languageClient) {
        languageClient.onReady().then(() => {
            languageClient.onNotification('pyright/beginProgress', () => __awaiter(this, void 0, void 0, function* () {
                const progressPromise = new Promise((resolve) => {
                    this._resolveProgress = resolve;
                });
                vscode_1.window.withProgress({
                    location: vscode_1.ProgressLocation.Window,
                    title: '',
                }, (progress) => {
                    this._progress = progress;
                    return progressPromise;
                });
                this._primeTimeoutTimer();
            }));
            languageClient.onNotification('pyright/reportProgress', (message) => {
                if (this._progress) {
                    this._progress.report({ message });
                    this._primeTimeoutTimer();
                }
            });
            languageClient.onNotification('pyright/endProgress', () => {
                this._clearProgress();
            });
        });
    }
    dispose() {
        this._clearProgress();
    }
    _clearProgress() {
        if (this._resolveProgress) {
            this._resolveProgress();
            this._resolveProgress = undefined;
        }
        if (this._progressTimeout) {
            clearTimeout(this._progressTimeout);
            this._progressTimeout = undefined;
        }
    }
    _primeTimeoutTimer() {
        if (this._progressTimeout) {
            clearTimeout(this._progressTimeout);
            this._progressTimeout = undefined;
        }
        this._progressTimeout = setTimeout(() => this._handleTimeout(), AnalysisTimeoutInMs);
    }
    _handleTimeout() {
        this._clearProgress();
    }
}
exports.ProgressReporting = ProgressReporting;
//# sourceMappingURL=progress.js.map