//
//  VMTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 03-02-21.
//

import XCTest
@testable import Rosetta
@testable import MonkeyLang

class VMTests: XCTestCase {
    typealias TestCase = (input: String, expected: Object)

    func testIntegerArithmetic() throws {
        let tests: [TestCase] = [
            ("1", Integer(1)),
            ("2", Integer(2)),
            ("1 + 2", Integer(3)),
            ("1 - 2", Integer(-1)),
            ("1 * 2", Integer(2)),
            ("4 / 2", Integer(2)),
            ("50 / 2 * 2 + 10 - 5", Integer(55)),
            ("5 + 5 + 5 + 5 - 10", Integer(10)),
            ("2 * 2 * 2 * 2 * 2", Integer(32)),
            ("5 * 2 + 10", Integer(20)),
            ("5 + 2 * 10", Integer(25)),
            ("5 * (2 + 10)", Integer(60))
        ]

        try self.runVMTests(tests)
    }

    // MARK: Utils

    func runVMTests(_ tests: [TestCase], file: StaticString = #file, line: UInt = #line) throws {
        for test in tests {
            let program = try parse(test.input)
            var compiler = MonkeyC()
            try compiler.compile(program)
            let bytecode = compiler.bytecode
            var vm = VM(bytecode, operations: MonkeyVMOperations())
            try vm.run()

            let element = vm.lastPoped
            XCTAssert(
                element?.isEquals(other: test.expected) ?? false,
                "\(element?.description ?? "nil") is not equal to \(test.expected)"
            )
        }
    }

    func parse(_ input: String, file: StaticString = #file, line: UInt = #line) throws -> Program {
        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)
        guard let program = try parser.parseProgram() else {
            XCTFail("Resulting program is nil")
            return Program(statements: [])
        }

        return program
    }
}
