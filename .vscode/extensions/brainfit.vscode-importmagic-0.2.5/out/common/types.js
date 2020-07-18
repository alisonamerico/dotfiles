"use strict";
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
Object.defineProperty(exports, "__esModule", { value: true });
exports.IProcessService = Symbol('IProcessService');
class StdErrError extends Error {
    constructor(message) {
        super(message);
    }
}
exports.StdErrError = StdErrError;
//# sourceMappingURL=types.js.map