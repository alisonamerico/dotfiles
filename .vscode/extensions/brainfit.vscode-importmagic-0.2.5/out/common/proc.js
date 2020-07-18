"use strict";
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
Object.defineProperty(exports, "__esModule", { value: true });
const child_process_1 = require("child_process");
const Observable_1 = require("rxjs/Observable");
const types_1 = require("./types");
const iconv = require("iconv-lite");
class ProcessService {
    execObservable(file, args, options = {}) {
        const encoding = 'utf8';
        const spawnOptions = Object.assign({}, options);
        if (!spawnOptions.env || Object.keys(spawnOptions).length === 0) {
            spawnOptions.env = Object.assign({}, process.env);
        }
        // Always ensure we have unbuffered output.
        spawnOptions.env.PYTHONUNBUFFERED = '1';
        if (!spawnOptions.env.PYTHONIOENCODING) {
            spawnOptions.env.PYTHONIOENCODING = 'utf-8';
        }
        const proc = child_process_1.spawn(file, args, spawnOptions);
        let procExited = false;
        const output = new Observable_1.Observable(subscriber => {
            const disposables = [];
            const on = (ee, name, fn) => {
                ee.on(name, fn);
                disposables.push({ dispose: () => ee.removeListener(name, fn) });
            };
            if (options.token) {
                disposables.push(options.token.onCancellationRequested(() => {
                    if (!procExited && !proc.killed) {
                        proc.kill();
                        procExited = true;
                    }
                }));
            }
            const sendOutput = (source, data) => {
                const out = iconv.decode(Buffer.concat([data]), encoding);
                if (source === 'stderr' && options.throwOnStdErr) {
                    subscriber.error(new types_1.StdErrError(out));
                }
                else {
                    subscriber.next({ source, out: out });
                }
            };
            on(proc.stdout, 'data', (data) => sendOutput('stdout', data));
            on(proc.stderr, 'data', (data) => sendOutput('stderr', data));
            proc.once('close', () => {
                procExited = true;
                subscriber.complete();
                disposables.forEach(disposable => disposable.dispose());
            });
            proc.once('error', ex => {
                procExited = true;
                subscriber.error(ex);
                disposables.forEach(disposable => disposable.dispose());
            });
        });
        return { proc, out: output };
    }
}
exports.ProcessService = ProcessService;
//# sourceMappingURL=proc.js.map