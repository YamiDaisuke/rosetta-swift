//
//  CompilerTests.swift
//  HermesTests
//
//  Created by Franklin Cruz on 22-04-21.
//

import XCTest
@testable import Hermes

private struct DummyType: VMBaseType, Compilable, Decompilable {
    func compile() throws -> [Byte] { [1] }

    init() { }
    init(fromBytes bytes: [Byte], readBytes: inout Int) throws { }

    var description: String {
        "dummy"
    }
}


private struct DummyCompiler: Compiler {
    var instructions: Instructions = []

    var scopes: [CompilationScope] = [CompilationScope()]
    var scopeIndex = 0
    var constants: [VMBaseType] = []
    var symbolTable = SymbolTable()

    init() {
    }

    mutating func compile(_ program: Program) throws {
    }

    mutating func compile(_ node: Node) throws {
    }
}

class CompilerTests: XCTestCase {
    func testConstantsAreCompiled() throws {
        let tests = [
            0,
            1,
            2,
            100
        ]

        for test in tests {
            var compiler = DummyCompiler()
            compiler.constants = Array(repeating: DummyType(), count: test)

            let bytecode = compiler.bytecode
            XCTAssertEqual(bytecode.compiledConstants.count, test)
            XCTAssertEqual(bytecode.constants.count, test)
            XCTAssertEqual(bytecode.compiledConstants, Array(repeating: 1, count: test))
        }
    }
}