//
//  MonkeyEvaluatorErrors.swift
//  Hermes
//
//  Created by Franklin Cruz on 13-01-21.
//

import Foundation
import Hermes

struct UnknownOperator: EvaluatorError, CompilerError, VMError {
    var message: String
    var line: Int?
    var column: Int?
    var file: String?

    init(_ operatorSymbol: String, line: Int? = nil, column: Int? = nil, file: String? = nil) {
        self.message = "Unknown operator \"\(operatorSymbol)\""
        self.line = line
        self.column = column
        self.file = file
    }
}

struct UnknownSyntaxToken: EvaluatorError {
    var message: String
    var line: Int?
    var column: Int?
    var file: String?

    init(_ node: Node, line: Int? = nil, column: Int? = nil) {
        self.message = "Unknown token \"\(node)\""
        self.line = line
        self.column = column
    }

    init(_ node: Token = Token(type: .ilegal, literal: "UNKNOWN"), line: Int? = nil, column: Int? = nil, file: String? = nil) {
        self.message = "Unknown token \"\(node)\""
        self.line = line
        self.column = column
        self.file = file
    }
}

struct InvalidPrefixExpression: EvaluatorError {
    var message: String
    var line: Int?
    var column: Int?
    var file: String?

    init(_ operatorSymbol: String, rhs: Object?, line: Int? = nil, column: Int? = nil, file: String? = nil) {
        let typeName = type(of: rhs ?? Null.null).type
        self.message = "Can't apply operator \"\(operatorSymbol)\" to \(typeName)"
        self.line = line
        self.column = column
        self.file = file
    }
}

struct InvalidInfixExpression: EvaluatorError, CompilerError {
    var message: String
    var line: Int?
    var column: Int?
    var file: String?

    init(_ operatorSymbol: String, lhs: Object?, rhs: Object?, line: Int? = nil, column: Int? = nil, file: String? = nil) {
        let lhsType = type(of: lhs ?? Null.null).type
        let rhsType = type(of: rhs ?? Null.null).type
        self.message = "Can't apply operator \"\(operatorSymbol)\" to \(lhsType) and \(rhsType)"
        self.line = line
        self.column = column
        self.file = file
    }
}

struct InvalidCallExpression: EvaluatorError {
    var message: String
    var line: Int?
    var column: Int?
    var file: String?

    init(_ type: ObjectType, line: Int? = nil, column: Int? = nil, file: String? = nil) {
        self.message = "Can't call expression of type: \(type)"
        self.line = line
        self.column = column
        self.file = file
    }
}

extension WrongArgumentCount: EvaluatorError {
    /// From VMError
}

struct InvalidArgumentType: EvaluatorError {
    var message: String
    var line: Int?
    var column: Int?
    var file: String?

    init(_ expected: ObjectType, got: ObjectType, line: Int? = nil, column: Int? = nil, file: String? = nil) {
        self.message = "Incorrect argment type expected: \(expected) got: \(got)"
        self.line = line
        self.column = column
        self.file = file
    }
}

struct InvalidHashKey: EvaluatorError, VMError {
    var message: String
    var line: Int?
    var column: Int?
    var file: String?

    init(_ got: ObjectType, line: Int? = nil, column: Int? = nil, file: String? = nil) {
        self.message = "Can't use type: \(got) as Hash Key"
        self.line = line
        self.column = column
        self.file = file
    }
}

struct TypeError: EvaluatorError {
    var message: String
    var line: Int?
    var column: Int?
    var file: String?

    init(_ got: ObjectType, expected: ObjectType, line: Int? = nil, column: Int? = nil, file: String? = nil) {
        self.message = "Can't assign value of type: \(got) to variable of type: \(expected)"
        self.line = line
        self.column = column
        self.file = file
    }
}
