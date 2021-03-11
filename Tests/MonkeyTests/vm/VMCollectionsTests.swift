//
//  VMCollectionsTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 11-03-21.
//

import XCTest
@testable import Rosetta
@testable import MonkeyLang

class VMCollectionsTests: XCTestCase, VMTestsHelpers {
    func testArrayLiterals() throws {
        let tests: [VMTestCase] = [
            ("[]", MArray(elements: [])),
            ("[1, 2, 3]", MArray(elements: [Integer(1), Integer(2), Integer(3)])),
            ("[1 + 2, 3 * 4, 5 + 6]", MArray(elements: [Integer(3), Integer(12), Integer(11)]))
        ]

        try self.runVMTests(tests)
    }

    func testHashLiterals() throws {
        let tests: [VMTestCase] = [
            ("{}", Hash(pairs: [:])),
            ("{1: 2, 2: 3}", Hash(pairs: [
                Integer(1): Integer(2),
                Integer(2): Integer(3)
            ])),
            ("{1 + 1: 2 * 2, 3 + 3: 4 * 4}", Hash(pairs: [
                Integer(2): Integer(4),
                Integer(6): Integer(16)
            ]))
        ]

        try self.runVMTests(tests)
    }

    func testIndexExpressions() throws {
        let tests: [VMTestCase] = [
            ("[1, 2, 3][1]", Integer(2)),
            ("[1, 2, 3][0 + 2]", Integer(3)),
            ("[[1, 1, 1]][0][0]", Integer(1)),
            ("[][0]", Null.null),
            ("[1, 2, 3][99]", Null.null),
            ("[1][-1]", Null.null),
            ("{1: 1, 2: 2}[1]", Integer(1)),
            ("{1: 1, 2: 2}[2]", Integer(2)),
            ("{1: 1}[0]", Null.null),
            ("{}[0]", Null.null)
        ]

        try self.runVMTests(tests)
    }
}
