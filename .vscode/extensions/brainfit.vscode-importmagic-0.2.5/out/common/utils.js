"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const fs = require("fs");
const path = require("path");
const tmp = require("tmp");
function isTestExecution() {
    // tslint:disable-next-line:interface-name no-string-literal
    return process.env['VSC_PYTHON_CI_TEST'] === '1';
}
exports.isTestExecution = isTestExecution;
function getTempFileWithDocumentContents(document) {
    return new Promise((resolve, reject) => {
        const ext = path.extname(document.uri.fsPath);
        tmp.file({ postfix: ext }, (err, tmpFilePath, fd) => {
            if (err) {
                return reject(err);
            }
            fs.writeFile(tmpFilePath, document.getText(), ex => {
                if (ex) {
                    return reject(`Failed to create a temporary file, ${ex.message}`);
                }
                resolve(tmpFilePath);
            });
        });
    });
}
exports.getTempFileWithDocumentContents = getTempFileWithDocumentContents;
//# sourceMappingURL=utils.js.map