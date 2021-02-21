//
//  MonkeyCompiler.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 01-02-21.
//

import Foundation
import Rosetta

/// Monkey Lang compiler for the Rosetta VM
public struct MonkeyC: Compiler {
    public typealias BaseType = Object

    public var instructions: Instructions = []
    public var lastInstruction: EmittedInstruction?
    public var prevInstruction: EmittedInstruction?
    public var constants: [Object] = []
    public var symbolTable = SymbolTable()

    public init() { }

    /// Creates a compiler instance with an existing `SymbolTable`
    /// - Parameter table: The existing table
    public init(withSymbolTable table: SymbolTable) {
        self.symbolTable = table
    }

    public mutating func compile(_ program: Program) throws {
        for node in program.statements {
            try self.compile(node)
        }
    }

    public mutating func compile(_ node: Node) throws {
        switch node {
        case let expresion as ExpressionStatement:
            try self.compile(expresion.expression)
            self.emit(.pop)
        case let prefix as PrefixExpression:
            let operatorCode = try opCode(forPrefixOperator: prefix.operatorSymbol)
            try self.compile(prefix.rhs)
            self.emit(operatorCode)
        case let infix as InfixExpression:
            let operatorCode = try opCode(forInfixOperator: infix.operatorSymbol)

            if infix.operatorSymbol == "<=" || infix.operatorSymbol == "<" {
                try self.compile(infix.rhs)
                try self.compile(infix.lhs)
            } else {
                try self.compile(infix.lhs)
                try self.compile(infix.rhs)
            }

            self.emit(operatorCode)
        case let condition as IfExpression:
            try self.compile(condition.condition)
            let jumpFPosition = self.emit(.jumpf, 9999)

            try self.compile(condition.consequence)
            self.removeLast { $0.code == .pop }

            let jumpPosition = self.emit(.jump, 9999)
            let afterConsequence = self.instructions.count
            self.replaceOperands(operands: [Int32(afterConsequence)], at: jumpFPosition)

            if let alternative = condition.alternative {
                try self.compile(alternative)
                self.removeLast { $0.code == .pop }
            } else {
                self.emit(.null)
            }

            let afterAlternative = self.instructions.count
            self.replaceOperands(operands: [Int32(afterAlternative)], at: jumpPosition)
        case let block as BlockStatement:
            for stmt in block.statements {
                try self.compile(stmt)
            }
        case let integer as IntegerLiteral:
            let value = Integer(integer.value)
            self.emit(.constant, self.addConstant(value))
        case let boolean as BooleanLiteral:
            self.emit(boolean.value ? .true : .false)
        case let declareStatement as DeclareStatement:
            try compile(declareStatement.value)
            let type: VariableType = declareStatement.token.type == .let ? .let : .var
            let symbol = try symbolTable.define(declareStatement.name.value, type: type)
            self.emit(.setGlobal, Int32(symbol.index))
        case let assignStatement as AssignStatement:
            try compile(assignStatement.value)
            let symbol = try symbolTable.resolve(assignStatement.name.value)

            guard symbol.type == .var else {
                throw AssignConstantError(assignStatement.name.value)
            }

            self.emit(.assignGlobal, Int32(symbol.index))
        case let identifier as Identifier:
            let symbol = try self.symbolTable.resolve(identifier.value)
            self.emit(.getGlobal, Int32(symbol.index))
        default:
            break
        }
    }

    /// Converts an infix operator string representation to the corresponding `OpCode`
    /// - Parameter operatorStr: The operator string
    /// - Throws: `UnknownOperator` if the string does not match any `OpCode`
    /// - Returns: The `OpCode`
    func opCode(forInfixOperator operatorStr: String) throws -> OpCodes {
        switch operatorStr {
        case "+":
            return .add
        case "-":
            return .sub
        case "*":
            return .mul
        case "/":
            return .div
        case ">", "<":
            return .gt
        case ">=", "<=":
            return .gte
        case "==":
            return .equal
        case "!=":
            return .notEqual
        default:
            throw UnknownOperator(operatorStr)
        }
    }

    /// Converts an prefix operator string representation to the corresponding `OpCode`
    /// - Parameter operatorStr: The operator string
    /// - Throws: `UnknownOperator` if the string does not match any `OpCode`
    /// - Returns: The `OpCode`
    func opCode(forPrefixOperator operatorStr: String) throws -> OpCodes {
        switch operatorStr {
        case "-":
            return .minus
        case "!":
            return .bang
        default:
            throw UnknownOperator(operatorStr)
        }
    }
}
