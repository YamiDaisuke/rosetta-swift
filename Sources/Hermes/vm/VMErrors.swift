//
//  VMErrors.swift
//  Hermes
//
//  Created by Franklin Cruz on 03-03-21.
//

import Foundation

/// All VM errors should implement this protocol
public protocol VMError: HermesError {
}

/// Throw this error when a program tries to push more than `kStackSize`
/// elements into the VM stack
public struct StackOverflow: VMError {
    public var message: String = "Stack overflow"
    public var line: Int?
    public var column: Int?
    public var file: String?
}

/// Throw this error when a instruction byte code doesn't match with on
/// of the VM supported operations
public struct UnknownOpCode: VMError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ code: OpCode) {
        self.message = String(format: "Unknown op code: %02X", code)
    }
}

/// Throw this when a value from the base lang is not usable as Hash key
public struct InvalidHashKey<BaseType>: VMError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ key: BaseType) {
        self.message = "Value: \(key) cannot be used as hash key"
    }
}

/// Throw this when a value from the base lang is not usable as index for arrays
public struct InvalidArrayIndex<BaseType>: VMError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ index: BaseType) {
        self.message = "Index \(index) can't be applied to type Array"
    }
}

/// Throw this when tryng to apply an index expression to a non-indexable value
public struct IndexNotSupported<BaseType>: VMError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ value: BaseType) {
        self.message = "Can't apply index to: \(value)"
    }
}

/// Throw this when tryng to call an value that is not a function
public struct CallingNonFunction<BaseType>: VMError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ value: BaseType) {
        self.message = "Calling non-function: \(value)"
    }
}


public struct WrongArgumentCount: VMError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ expected: Int, got: Int, line: Int? = nil, column: Int? = nil, file: String? = nil) {
        self.message = "Incorrect number of arguments in function call expected: \(expected) but got: \(got)"
        self.line = line
        self.column = column
        self.file = file
    }
}

/// Throw this error when the VM is trying to execute a binary file
/// that was not compiled with a Hermes compiler
public struct InvalidBinary: VMError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ filePath: URL, line: Int? = nil, column: Int? = nil, file: String? = nil) {
        self.message = "Invalid binary file: \(filePath.absoluteString)"
        self.line = line
        self.column = column
        self.file = file
    }
}

/// Throw this error when the VM is trying to execute a binary file
/// that it is targeting a different language than the current VM instance
public struct InvalidLanguage: VMError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ filePath: URL, line: Int? = nil, column: Int? = nil, file: String? = nil) {
        self.message = "Invalid original language for file: \(filePath.absoluteString)"
        self.line = line
        self.column = column
        self.file = file
    }
}


/// Throw this error when the VM is trying to execute a binary file
/// that it is targeting an incompatible Hermes version
public struct InvalidVersion: VMError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ current: SemVersion, expected: SemVersion, line: Int? = nil, column: Int? = nil, file: String? = nil) {
        self.message = "Invalid Hermes version: \(current). Expecte: \(expected)"
        self.line = line
        self.column = column
        self.file = file
    }
}
