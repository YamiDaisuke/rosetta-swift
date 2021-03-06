//
//  VMTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 03-02-21.
//

import XCTest
@testable import Hermes
@testable import MonkeyLang

class VMTests: XCTestCase, VMTestsHelpers {
    func testIntegerArithmetic() throws {
        let tests: [VMTestCase] = [
            VMTestCase("1", Integer(1)),
            VMTestCase("2", Integer(2)),
            VMTestCase("1 + 2", Integer(3)),
            VMTestCase("1 - 2", Integer(-1)),
            VMTestCase("1 * 2", Integer(2)),
            VMTestCase("4 / 2", Integer(2)),
            VMTestCase("50 / 2 * 2 + 10 - 5", Integer(55)),
            VMTestCase("5 + 5 + 5 + 5 - 10", Integer(10)),
            VMTestCase("2 * 2 * 2 * 2 * 2", Integer(32)),
            VMTestCase("5 * 2 + 10", Integer(20)),
            VMTestCase("5 + 2 * 10", Integer(25)),
            VMTestCase("5 * (2 + 10)", Integer(60)),
            VMTestCase("-5", Integer(-5)),
            VMTestCase("-10", Integer(-10)),
            VMTestCase("-50 + 100 + -50", Integer(0)),
            VMTestCase("(5 + 10 * 2 + 15 / 3) * 2 + -10", Integer(50))
        ]

        try self.runVMTests(tests)
    }

    func testBooleanExpressions() throws {
        let tests: [VMTestCase] = [
            VMTestCase("true", Boolean.true),
            VMTestCase("false", Boolean.false),
            VMTestCase("1 < 2", Boolean.true),
            VMTestCase("1 > 2", Boolean.false),
            VMTestCase("1 >= 2", Boolean.false),
            VMTestCase("1 <= 2", Boolean.true),
            VMTestCase("1 < 1", Boolean.false),
            VMTestCase("1 <= 1", Boolean.true),
            VMTestCase("1 > 1", Boolean.false),
            VMTestCase("1 >= 1", Boolean.true),
            VMTestCase("1 == 1", Boolean.true),
            VMTestCase("1 != 1", Boolean.false),
            VMTestCase("1 == 2", Boolean.false),
            VMTestCase("1 != 2", Boolean.true),
            VMTestCase("true == true", Boolean.true),
            VMTestCase("false == false", Boolean.true),
            VMTestCase("true == false", Boolean.false),
            VMTestCase("true != false", Boolean.true),
            VMTestCase("false != true", Boolean.true),
            VMTestCase("(1 < 2) == true", Boolean.true),
            VMTestCase("(1 < 2) == false", Boolean.false),
            VMTestCase("(1 > 2) == true", Boolean.false),
            VMTestCase("(1 > 2) == false", Boolean.true),
            VMTestCase("(1 <= 2) == true", Boolean.true),
            VMTestCase("(1 <= 2) == false", Boolean.false),
            VMTestCase("(1 >= 2) == true", Boolean.false),
            VMTestCase("(1 >= 2) == false", Boolean.true),
            VMTestCase("!true", Boolean.false),
            VMTestCase("!false", Boolean.true),
            VMTestCase("!5", Boolean.false),
            VMTestCase("!!true", Boolean.true),
            VMTestCase("!!false", Boolean.false),
            VMTestCase("!!5", Boolean.true),
            VMTestCase("!(if (false) { 5; })", Boolean.true)
        ]

        try self.runVMTests(tests)
    }

    func testFloatExpressions() throws {
        let tests = [
            VMTestCase("5.0", MFloat(5.0)),
            VMTestCase("0.10", MFloat(0.10)),
            VMTestCase("-5.5", MFloat(-5.5)),
            VMTestCase("-0.10", MFloat(-0.10)),
            VMTestCase("2.5 + 2.5", MFloat(5.0)),
            VMTestCase("2.5 + 2", MFloat(4.5)),
            VMTestCase("2 + 2.5", MFloat(4.5)),
            VMTestCase("2.0 * 1.0", MFloat(2.0)),
            VMTestCase("2.0 * 1", MFloat(2.0)),
            VMTestCase("2 * 1.0", MFloat(2.0)),
            VMTestCase("5.0 / 2.0", MFloat(2.5)),
            VMTestCase("5.0 / 2", MFloat(2.5)),
            VMTestCase("5 / 2.0", MFloat(2.5)),
            VMTestCase("5.0 - 2.0", MFloat(3.0)),
            VMTestCase("5.0 - 2", MFloat(3.0)),
            VMTestCase("5 - 2.0", MFloat(3.0))
        ]

        try self.runVMTests(tests)
    }

    func testStringExpressions() throws {
        let tests: [VMTestCase] = [
            VMTestCase("\"monkey\"", MString("monkey")),
            VMTestCase("\"mon\" + \"key\"", MString("monkey")),
            VMTestCase("\"mon\" + \"key\" + \"banana\"", MString("monkeybanana")),
            VMTestCase("\"mon\" + \"key\" + 2", MString("monkey2"))
        ]

        try self.runVMTests(tests)
    }

    func testConditionals() throws {
        let tests: [VMTestCase] = [
            VMTestCase("if (true) { 10 }", Integer(10)),
            VMTestCase("if (true) { 10 } else { 20 }", Integer(10)),
            VMTestCase("if (false) { 10 } else { 20 }", Integer(20)),
            VMTestCase("if (1) { 10 }", Integer(10)),
            VMTestCase("if (1 < 2) { 10 }", Integer(10)),
            VMTestCase("if (1 < 2) { 10 } else { 20 }", Integer(10)),
            VMTestCase("if (1 > 2) { 10 } else { 20 }", Integer(20)),
            VMTestCase("if (1 > 2) { 10 }", Null.null),
            VMTestCase("if (false) { 10 }", Null.null),
            VMTestCase("if ((if (false) { 10 })) { 10 } else { 20 }", Integer(20))
        ]

        try self.runVMTests(tests)
    }

    func testGlobalLetStatements() throws {
        let tests: [VMTestCase] = [
            VMTestCase("let one = 1; one;", Integer(1)),
            VMTestCase("let one = 1; let two = 2; one + two", Integer(3)),
            VMTestCase("let one = 1; let two = one + one; one + two", Integer(3)),
            // This should fail because we are trying to assing a let value
            VMTestCase("let fail = 1; fail = 10;", Null.null, "Cannot assign to value: \"fail\" is a constant"),
            // This should fail because we are trying to create a new global with the same name
            VMTestCase("let fail = 1; let fail = 10;", Null.null, "Cannot redeclare: \"fail\" it already exists")
        ]

        for test in tests {
            do {
                try self.runVMTest(test)
            } catch let error as AssignConstantError {
                // How awesome it is that we catch the error at compile time!!
                XCTAssertEqual(error.message, test.error)
            } catch let error as RedeclarationError {
                // How awesome it is that we catch the error at compile time!!
                XCTAssertEqual(error.message, test.error)
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func testGlobalVarStatements() throws {
        let tests: [VMTestCase] = [
            VMTestCase("var one = 1; one;", Integer(1)),
            VMTestCase("var one = 1; var two = 2; one + two", Integer(3)),
            VMTestCase("var one = 1; var two = one + one; one + two", Integer(3)),
            VMTestCase("var one = 1; one = 3; one", Integer(3))
        ]

        try self.runVMTests(tests)
    }

    func testConstantDecompile() throws {
        let tests: [[VMBaseType]] = [
            [],
            [Integer(1)],
            [Integer(1), Integer(2)],
            [Integer(1), MString("2")],
            [Integer(1), MArray(elements: [Integer(1), MString("2")])]
        ]

        for test in tests {
            let bytes: [Byte] = test.reduce([]) {
                let out = try? $1.compile()
                return $0 + (out ?? [])
            }

            let monkeyVMOperations = MonkeyVMOperations()
            let constants = try monkeyVMOperations.decompileConstants(fromBytes: bytes)
            MKAssertConstants(constants, test)
        }
    }

    func testExecuteBinary() throws {
        let path = FileManager.default.temporaryDirectory
        let tests = [
            VMTestCase("true", Boolean.true),
            VMTestCase("false", Boolean.false),
            VMTestCase("1 < 2", Boolean.true),
            VMTestCase("1 > 2", Boolean.false),
            VMTestCase("var one = 1; var two = one + one; one + two", Integer(3)),
            VMTestCase("(5 + 10 * 2 + 15 / 3) * 2 + -10", Integer(50)),
            VMTestCase("len(\"\")", Integer(0)),
            VMTestCase(
                """
                let newClosure = fn(a) {
                    fn() { a; }
                };
                let closure = newClosure(99);
                closure();
                """,
                Integer(99)
            )
        ]

        for test in tests {
            let program = try parse(test.input)
            var compiler = MonkeyC()
            try compiler.compile(program)
            let filePath = path.appendingPathComponent("test\(Date.timeIntervalSinceReferenceDate).mkc")
            compiler.writeToFile(filePath)

            var vm = try VM(filePath, operations: MonkeyVMOperations())
            try vm.run()

            let element = vm.lastPoped as? Object
            XCTAssert(
                element?.isEquals(other: test.expected) ?? false,
                "\(element?.description ?? "nil") is not equal to \(test.expected)"
            )
        }
    }
}
