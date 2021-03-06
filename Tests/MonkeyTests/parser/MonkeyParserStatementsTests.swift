//
//  MonkeyParserStatementsTests.swift
//  HermesTest
//
//  Created by Franklin Cruz on 05-01-21.
//

import XCTest
@testable import Hermes
@testable import MonkeyLang

class MonkeyParserStatementsTests: XCTestCase {
    func testParseLetStatementErrors() throws {
        let input = """
        let 5;
        let y 10;
        """
        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        do {
            _ = try parser.parseProgram()
        } catch let error as AllParserError {
            XCTAssertEqual(error.errors.count, 2)
            XCTAssert(error.errors[0] is MissingExpected)
            XCTAssertEqual(error.errors[0].message, "Expected token \"identifier\"")

            XCTAssert(error.errors[1] is MissingExpected)
            XCTAssertEqual(error.errors[1].message, "Expected token \"=\"")
        }
    }

    func testParseLetStatement() throws {
        let tests = [
            (input: "let x = 5;", identifier: "x", val: "5", type: "int"),
            (input: "let y = true;", identifier: "y", val: "true", type: "bool"),
            (input: "let foobar = y;", identifier: "foobar", val: "y", type: "identifier")
        ]

        for test in tests {
            let lexer = MonkeyLexer(withString: test.input)
            var parser = MonkeyParser(lexer: lexer)

            let program = try parser.parseProgram()
            XCTAssertNotNil(program)
            XCTAssertEqual(program?.statements.count, 1)

            let statement = program?.statements.first
            XCTAssertEqual(statement?.literal, "let")
            let letStatement = statement as? DeclareStatement
            XCTAssertNotNil(letStatement)
            XCTAssertEqual(letStatement?.name.literal, test.identifier)

            if test.type == "int" {
                let value = letStatement?.value as? IntegerLiteral
                XCTAssertNotNil(value)
                XCTAssertEqual(value?.value.description, test.val)
            }

            if test.type == "bool" {
                let value = letStatement?.value as? BooleanLiteral
                XCTAssertNotNil(value)
                XCTAssertEqual(value?.value.description, test.val)
            }

            if test.type == "identifier" {
                let value = letStatement?.value as? Identifier
                XCTAssertNotNil(value)
                XCTAssertEqual(value?.value, test.val)
            }
        }
    }

    func testParseVarStatement() throws {
        let tests = [
            (input: "var x = 5;", identifier: "x", val: "5", type: "int"),
            (input: "var y = true;", identifier: "y", val: "true", type: "bool"),
            (input: "var foobar = y;", identifier: "foobar", val: "y", type: "identifier")
        ]

        for test in tests {
            let lexer = MonkeyLexer(withString: test.input)
            var parser = MonkeyParser(lexer: lexer)

            let program = try parser.parseProgram()
            XCTAssertNotNil(program)
            XCTAssertEqual(program?.statements.count, 1)

            let statement = program?.statements.first
            XCTAssertEqual(statement?.literal, "var")
            let varStatement = statement as? DeclareStatement
            XCTAssertNotNil(varStatement)
            XCTAssertEqual(varStatement?.name.literal, test.identifier)

            if test.type == "int" {
                let value = varStatement?.value as? IntegerLiteral
                XCTAssertNotNil(value)
                XCTAssertEqual(value?.value.description, test.val)
            }

            if test.type == "bool" {
                let value = varStatement?.value as? BooleanLiteral
                XCTAssertNotNil(value)
                XCTAssertEqual(value?.value.description, test.val)
            }

            if test.type == "identifier" {
                let value = varStatement?.value as? Identifier
                XCTAssertNotNil(value)
                XCTAssertEqual(value?.value, test.val)
            }
        }
    }

    func testParseAssignStatement() throws {
        let tests = [
            (input: "x = 10;", identifier: "x", val: "10", type: "int"),
            (input: "y = true;", identifier: "y", val: "true", type: "bool"),
            (input: "foobar = y;", identifier: "foobar", val: "y", type: "identifier")
        ]

        for test in tests {
            let lexer = MonkeyLexer(withString: test.input)
            var parser = MonkeyParser(lexer: lexer)

            let program = try parser.parseProgram()
            XCTAssertNotNil(program)
            XCTAssertEqual(program?.statements.count, 1)

            let statement = program?.statements.first
            XCTAssertEqual(statement?.literal, test.identifier)
            let assignStatement = statement as? AssignStatement
            XCTAssertNotNil(assignStatement)
            XCTAssertEqual(assignStatement?.name.literal, test.identifier)

            if test.type == "int" {
                let value = assignStatement?.value as? IntegerLiteral
                XCTAssertNotNil(value)
                XCTAssertEqual(value?.value.description, test.val)
            }

            if test.type == "bool" {
                let value = assignStatement?.value as? BooleanLiteral
                XCTAssertNotNil(value)
                XCTAssertEqual(value?.value.description, test.val)
            }

            if test.type == "identifier" {
                let value = assignStatement?.value as? Identifier
                XCTAssertNotNil(value)
                XCTAssertEqual(value?.value, test.val)
            }
        }
    }

    func testReturnStatement() throws {
        let tests = [
            (input: "return 5;", val: "5", type: "int"),
            (input: "return true;", val: "true", type: "bool"),
            (input: "return foobar;", val: "foobar", type: "identifier"),
            (input: "return 9999;", val: "9999", type: "int")
        ]

        for test in tests {
            let lexer = MonkeyLexer(withString: test.input)
            var parser = MonkeyParser(lexer: lexer)

            let program = try parser.parseProgram()
            XCTAssertNotNil(program)
            XCTAssertEqual(program?.statements.count, 1)
            let returnStatement = program?.statements.first as? ReturnStatement
            XCTAssertNotNil(returnStatement)

            if test.type == "int" {
                let value = returnStatement?.value as? IntegerLiteral
                XCTAssertNotNil(value)
                XCTAssertEqual(value?.value.description, test.val)
            }

            if test.type == "bool" {
                let value = returnStatement?.value as? BooleanLiteral
                XCTAssertNotNil(value)
                XCTAssertEqual(value?.value.description, test.val)
            }

            if test.type == "identifier" {
                let value = returnStatement?.value as? Identifier
                XCTAssertNotNil(value)
                XCTAssertEqual(value?.value, test.val)
            }
        }
    }
}
