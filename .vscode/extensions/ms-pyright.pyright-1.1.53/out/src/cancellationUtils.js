"use strict";
/*
 * cancellationUtils.ts
 * Copyright (c) Microsoft Corporation.
 * Licensed under the MIT license.
 *
 * Helper methods around cancellation
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.FileBasedCancellationStrategy = void 0;
const crypto_1 = require("crypto");
const fs = require("fs");
const os = require("os");
const path = require("path");
const vscode_languageserver_1 = require("vscode-languageserver");
function getCancellationFolderPath(folderName) {
    return path.join(os.tmpdir(), 'python-languageserver-cancellation', folderName);
}
function getCancellationFilePath(folderName, id) {
    return path.join(getCancellationFolderPath(folderName), `cancellation-${String(id)}.tmp`);
}
function tryRun(callback) {
    try {
        callback();
    }
    catch (e) {
        /* empty */
    }
}
class FileCancellationSenderStrategy {
    constructor(folderName) {
        this.folderName = folderName;
        const folder = getCancellationFolderPath(folderName);
        tryRun(() => fs.mkdirSync(folder, { recursive: true }));
    }
    sendCancellation(_, id) {
        const file = getCancellationFilePath(this.folderName, id);
        tryRun(() => fs.writeFileSync(file, '', { flag: 'w' }));
    }
    cleanup(id) {
        tryRun(() => fs.unlinkSync(getCancellationFilePath(this.folderName, id)));
    }
    dispose() {
        const folder = getCancellationFolderPath(this.folderName);
        tryRun(() => rimraf(folder));
        function rimraf(location) {
            const stat = fs.lstatSync(location);
            if (stat) {
                if (stat.isDirectory() && !stat.isSymbolicLink()) {
                    for (const dir of fs.readdirSync(location)) {
                        rimraf(path.join(location, dir));
                    }
                    fs.rmdirSync(location);
                }
                else {
                    fs.unlinkSync(location);
                }
            }
        }
    }
}
class FileBasedCancellationStrategy {
    constructor() {
        const folderName = crypto_1.randomBytes(21).toString('hex');
        this._sender = new FileCancellationSenderStrategy(folderName);
    }
    get receiver() {
        return vscode_languageserver_1.CancellationReceiverStrategy.Message;
    }
    get sender() {
        return this._sender;
    }
    getCommandLineArguments() {
        return [`--cancellationReceive=file:${this._sender.folderName}`];
    }
    dispose() {
        this._sender.dispose();
    }
}
exports.FileBasedCancellationStrategy = FileBasedCancellationStrategy;
//# sourceMappingURL=cancellationUtils.js.map