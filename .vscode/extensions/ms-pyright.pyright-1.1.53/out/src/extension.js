"use strict";
/*
 * extension.ts
 *
 * Copyright (c) Microsoft Corporation.
 * Licensed under the MIT license.
 *
 * Provides client for Pyright Python language server. This portion runs
 * in the context of the VS Code process and talks to the server, which
 * runs in another process.
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
exports.deactivate = exports.activate = void 0;
const fs = require("fs");
const path = require("path");
const vscode_1 = require("vscode");
const node_1 = require("vscode-languageclient/node");
const cancellationUtils_1 = require("./cancellationUtils");
const progress_1 = require("./progress");
let cancellationStrategy;
function activate(context) {
    cancellationStrategy = new cancellationUtils_1.FileBasedCancellationStrategy();
    const bundlePath = context.asAbsolutePath(path.join('server', 'server.bundle.js'));
    const nonBundlePath = context.asAbsolutePath(path.join('server', 'src', 'server.js'));
    const debugOptions = { execArgv: ['--nolazy', '--inspect=6600'] };
    // If the extension is launched in debug mode, then the debug server options are used.
    const serverOptions = {
        run: { module: bundlePath, transport: node_1.TransportKind.ipc, args: cancellationStrategy.getCommandLineArguments() },
        // In debug mode, use the non-bundled code if it's present. The production
        // build includes only the bundled package, so we don't want to crash if
        // someone starts the production extension in debug mode.
        debug: {
            module: fs.existsSync(nonBundlePath) ? nonBundlePath : bundlePath,
            transport: node_1.TransportKind.ipc,
            args: cancellationStrategy.getCommandLineArguments(),
            options: debugOptions,
        },
    };
    // Options to control the language client
    const clientOptions = {
        // Register the server for python source files.
        documentSelector: [
            {
                scheme: 'file',
                language: 'python',
            },
        ],
        synchronize: {
            // Synchronize the setting section to the server.
            configurationSection: ['python', 'pyright'],
        },
        connectionOptions: { cancellationStrategy: cancellationStrategy },
        middleware: {
            // Use the middleware hook to override the configuration call. This allows
            // us to inject the proper "python.pythonPath" setting from the Python extension's
            // private settings store.
            workspace: {
                configuration: (params, token, next) => {
                    // Hand-collapse "Thenable<A> | Thenable<B> | Thenable<A|B>" into just "Thenable<A|B>" to make TS happy.
                    const result = next(params, token);
                    // For backwards compatibility, set python.pythonPath to the configured
                    // value as though it were in the user's settings.json file.
                    const addPythonPath = (settings) => {
                        if (settings instanceof node_1.ResponseError) {
                            return Promise.resolve(settings);
                        }
                        const pythonPathPromises = params.items.map((item) => {
                            if (item.section === 'python') {
                                const uri = item.scopeUri ? vscode_1.Uri.parse(item.scopeUri) : undefined;
                                return getPythonPathFromPythonExtension(languageClient.outputChannel, uri);
                            }
                            return Promise.resolve(undefined);
                        });
                        return Promise.all(pythonPathPromises).then((pythonPaths) => {
                            pythonPaths.forEach((pythonPath, i) => {
                                // If there is a pythonPath returned by the Python extension,
                                // always prefer this over the pythonPath that uses the old
                                // mechanism.
                                if (pythonPath !== undefined) {
                                    settings[i].pythonPath = pythonPath;
                                }
                            });
                            return settings;
                        });
                    };
                    if (isThenable(result)) {
                        return result.then(addPythonPath);
                    }
                    return addPythonPath(result);
                },
            },
        },
    };
    // Create the language client and start the client.
    const languageClient = new node_1.LanguageClient('python', 'Pyright', serverOptions, clientOptions);
    const disposable = languageClient.start();
    // Push the disposable to the context's subscriptions so that the
    // client can be deactivated on extension deactivation.
    context.subscriptions.push(disposable);
    // Allocate a progress reporting object.
    const progressReporting = new progress_1.ProgressReporting(languageClient);
    context.subscriptions.push(progressReporting);
    // Register our custom commands.
    const textEditorCommands = ["pyright.organizeimports" /* orderImports */, "pyright.addoptionalforparam" /* addMissingOptionalToParam */];
    textEditorCommands.forEach((commandName) => {
        context.subscriptions.push(vscode_1.commands.registerTextEditorCommand(commandName, (editor, edit, ...args) => {
            const cmd = {
                command: commandName,
                arguments: [editor.document.uri.toString(), ...args],
            };
            languageClient
                .sendRequest('workspace/executeCommand', cmd)
                .then((edits) => {
                if (edits && edits.length > 0) {
                    editor.edit((editBuilder) => {
                        edits.forEach((edit) => {
                            const startPos = new vscode_1.Position(edit.range.start.line, edit.range.start.character);
                            const endPos = new vscode_1.Position(edit.range.end.line, edit.range.end.character);
                            const range = new vscode_1.Range(startPos, endPos);
                            editBuilder.replace(range, edit.newText);
                        });
                    });
                }
            });
        }, () => {
            // Error received. For now, do nothing.
        }));
    });
    const genericCommands = ["pyright.createtypestub" /* createTypeStub */, "pyright.restartserver" /* restartServer */];
    genericCommands.forEach((command) => {
        context.subscriptions.push(vscode_1.commands.registerCommand(command, (...args) => {
            languageClient.sendRequest('workspace/executeCommand', { command, arguments: args });
        }));
    });
}
exports.activate = activate;
function deactivate() {
    if (cancellationStrategy) {
        cancellationStrategy.dispose();
        cancellationStrategy = undefined;
    }
    // Return undefined rather than a promise to indicate
    // that deactivation is done synchronously. We don't have
    // anything to do here.
    return undefined;
}
exports.deactivate = deactivate;
// The VS Code Python extension manages its own internal store of configuration settings.
// The setting that was traditionally named "python.pythonPath" has been moved to the
// Python extension's internal store for reasons of security and because it differs per
// project and by user.
function getPythonPathFromPythonExtension(outputChannel, scopeUri) {
    var _a, _b;
    return __awaiter(this, void 0, void 0, function* () {
        try {
            const extension = vscode_1.extensions.getExtension('ms-python.python');
            if (!extension) {
                outputChannel.appendLine('Python extension not found');
            }
            else {
                if ((_b = (_a = extension.packageJSON) === null || _a === void 0 ? void 0 : _a.featureFlags) === null || _b === void 0 ? void 0 : _b.usingNewInterpreterStorage) {
                    if (!extension.isActive) {
                        outputChannel.appendLine('Waiting for Python extension to load');
                        yield extension.activate();
                        outputChannel.appendLine('Python extension loaded');
                    }
                    const result = yield extension.exports.settings.getExecutionCommand(scopeUri).join(' ');
                    if (!result) {
                        outputChannel.appendLine(`No pythonPath provided by Python extension`);
                    }
                    else {
                        outputChannel.appendLine(`Received pythonPath from Python extension: ${result}`);
                    }
                    return result;
                }
            }
        }
        catch (error) {
            outputChannel.appendLine(`Exception occurred when attempting to read pythonPath from Python extension: ${JSON.stringify(error)}`);
        }
        return undefined;
    });
}
function isThenable(v) {
    return typeof (v === null || v === void 0 ? void 0 : v.then) === 'function';
}
//# sourceMappingURL=extension.js.map