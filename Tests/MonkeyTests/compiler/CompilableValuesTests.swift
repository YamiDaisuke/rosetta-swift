//
//  CompilableTests.swift
//  HermesTests
//
//  Created by Franklin Cruz on 09-04-21.
//

import XCTest
@testable import Hermes
@testable import MonkeyLang

// swiftlint:disable type_body_length

class CompilableValuesTests: XCTestCase {
    func testIntCompile() throws {
        let tests: [Int32] = [
            64,
            255,
            -255,
            65536
        ]

        for test in tests {
            let expectedType = MonkeyTypes.integer.rawValue

            let integer = Integer(test)
            let bytes = integer.compile()

            XCTAssertEqual(expectedType.hexa, bytes[0..<1].hexa)
            XCTAssertEqual(test, bytes.readInt(bytes: 4, startIndex: 1))
        }
    }

    func testIntDecompile() throws {
        let integerTypeBytes = MonkeyTypes.integer.bytes

        let tests: [([Byte], Int32)] = [
            (integerTypeBytes + [0, 0, 0, 64], 64),
            (integerTypeBytes + [0, 0, 0, 255], 255),
            // two's complement
            (integerTypeBytes + [255, 255, 255, 1], -255),
            (integerTypeBytes + [0, 1, 0, 0], 65536)
        ]

        for test in tests {
            let integer = try Integer(fromBytes: test.0)
            XCTAssertEqual(test.1, integer.value)
        }
    }

    func testMFloatCompile() throws {
        let tests: [Float64] = [
            64.5,
            255.0,
            -255.255,
            Float64.greatestFiniteMagnitude
        ]

        for test in tests {
            let expectedType = MonkeyTypes.float.rawValue

            let float = MFloat(test)
            let bytes = float.compile()

            XCTAssertEqual(expectedType.hexa, bytes[0..<1].hexa)
            let data = Data(bytes[1..<9])
            let bitPattern = UInt64(bigEndian: data.withUnsafeBytes { $0.load(as: UInt64.self) })
            let value = Float64(bitPattern: bitPattern)
            XCTAssertEqual(test, value)
        }
    }

    func testMFloatDecompile() throws {
        let typeBytes = MonkeyTypes.float.bytes

        let tests: [([Byte], Float64)] = [
            (typeBytes + [0x40, 0x50, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00], 64.5),
            (typeBytes + [0x40, 0x6F, 0xE0, 0x00, 0x00, 0x00, 0x00, 0x00], 255.0),
            (typeBytes + [0xC0, 0x6F, 0xE8, 0x28, 0xF5, 0xC2, 0x8F, 0x5C], -255.255),
            (typeBytes + [0x7F, 0xEF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF], Float64.greatestFiniteMagnitude)
        ]

        for test in tests {
            let float = try MFloat(fromBytes: test.0)
            XCTAssertEqual(test.1, float.value)
        }
    }

    func testBooleanCompile() throws {
        let tests: [Bool] = [
            true,
            false
        ]

        for test in tests {
            let expectedType = MonkeyTypes.boolean.rawValue

            let boolean = Boolean(test)
            let bytes = boolean.compile()

            XCTAssertEqual(expectedType.hexa, bytes[0..<1].hexa)
            XCTAssertEqual(test ? 1 : 0, bytes.readInt(bytes: 1, startIndex: 1))
        }
    }

    func testBooleanDecompile() throws {
        let typeBytes = MonkeyTypes.boolean.bytes
        let tests: [([Byte], Bool)] = [
            (typeBytes + [1], true),
            (typeBytes + [0], false)
        ]

        for test in tests {
            let boolean = try Boolean(fromBytes: test.0)
            XCTAssertEqual(test.1, boolean.value)
        }
    }

    func testNullCompile() throws {
        let expectedType = MonkeyTypes.null.rawValue

        let bytes = Null.null.compile()

        XCTAssertEqual(expectedType.hexa, bytes[0..<1].hexa)
        XCTAssertEqual(bytes.count, 1)
    }

    func testNullDecompile() throws {
        let typeBytes = MonkeyTypes.null.bytes
        let tests: [([Byte], Null)] = [
            (typeBytes, .null),
            (typeBytes, .null)
        ]

        for test in tests {
            let null = try Null(fromBytes: test.0)
            XCTAssert(test.1.isEquals(other: null))
        }
    }

    func testMStringCompile() throws {
        let tests = [
            "A",
            "Short",
            "And a normally not quite but enough long",
            "With 🍺",
            "日本語"
        ]

        for test in tests {
            let expectedType = MonkeyTypes.string.rawValue

            let mstring = MString(test)
            let bytes = mstring.compile()

            XCTAssertEqual(expectedType.hexa, bytes[0..<1].hexa)
            XCTAssertEqual(test.lengthOfBytes(using: .utf8), Int(bytes.readInt(bytes: 4, startIndex: 1) ?? 0))
            XCTAssertEqual(test, String(bytes: bytes[5...], encoding: .utf8))
        }
    }

    func testMStringDecompile() throws {
        let typeBytes = MonkeyTypes.string.bytes
        let tests: [([Byte], String)] = [
            (typeBytes + [0, 0, 0, 1] + [0x41], "A"),
            (typeBytes + [0, 0, 0, 5] + [0x53, 0x68, 0x6f, 0x72, 0x74], "Short"),
            (typeBytes + [0, 0, 0, 4] + [0xf0, 0x9f, 0x8d, 0xba], "🍺"),
            // This one includes junk bytes at the end
            (typeBytes + [0, 0, 0, 1] + [0x41, 66, 66, 66, 66], "A"),
            (typeBytes + [0, 0, 0, 9] + [0xe6, 0x97, 0xa5, 0xe6, 0x9c, 0xac, 0xe8, 0xaa, 0x9e], "日本語")
        ]

        for test in tests {
            let mstring = try MString(fromBytes: test.0)
            XCTAssertEqual(test.1, mstring.value)
        }
    }

    func testMArrayCompile() throws {
        let tests: [MArray] = [
            MArray(elements: []),
            MArray(elements: [Integer(1), Integer(2)]),
            MArray(elements: [Integer(1), Boolean.false]),
            MArray(elements: [Boolean.true, MString("false")]),
            MArray(elements: [
                MArray(elements: []),
                MArray(elements: [Integer(1), Integer(2)])
            ])
        ]

        for test in tests {
            let expectedType = MonkeyTypes.array.rawValue

            let bytes = try test.compile()

            XCTAssertEqual(expectedType.hexa, bytes[0..<1].hexa)
            XCTAssertEqual(test.elements.count, Int(bytes.readInt(bytes: 4, startIndex: 1) ?? -1))
            var startIndex = 5
            for element in test.elements {
                let elementBytes = try element.compile()
                let current = Array(bytes[startIndex..<(startIndex + elementBytes.count)])
                XCTAssertEqual(elementBytes, current)
                startIndex += elementBytes.count
            }
        }
    }

    func testMArrayDecompile() throws {
        let typeBytes = MonkeyTypes.array.bytes
        let innerArrayTest1 = try MArray(elements: []).compile()
        let innerArrayTest2 = try MArray(elements: [Integer(1), Integer(2)]).compile()

        let tests: [([Byte], MArray)] = [
            (typeBytes + [0, 0, 0, 0], MArray(elements: [])),
            (
                typeBytes + [0, 0, 0, 2] + Integer(1).compile() + Integer(2).compile(),
                MArray(elements: [Integer(1), Integer(2)])
            ),
            (
                typeBytes + [0, 0, 0, 2] + Integer(1).compile() + Boolean.false.compile(),
                MArray(elements: [Integer(1), Boolean.false])
            ),
            (
                typeBytes + [0, 0, 0, 2] + Boolean.true.compile() + MString("false").compile(),
                MArray(elements: [Boolean.true, MString("false")])
            ),
            (
                typeBytes + [0, 0, 0, 2] + innerArrayTest1 + innerArrayTest2,
                MArray(elements: [
                    MArray(elements: []),
                    MArray(elements: [Integer(1), Integer(2)])
                ])
            )
        ]

        for test in tests {
            let array = try MArray(fromBytes: test.0)
            XCTAssert(test.1.isEquals(other: array))
        }
    }

    func testHashCompile() throws {
        let tests: [Hash] = [
            Hash(pairs: [:]),
            Hash(pairs: [Integer(0): Integer(1)]),
            Hash(pairs: [MString("a"): Integer(1)]),
            Hash(pairs: [MString("a"): Integer(1), MString("b"): Boolean.true]),
            Hash(pairs: [MString("a"): Hash(pairs: [:])])
        ]

        for test in tests {
            let expectedType = MonkeyTypes.hash.rawValue

            let bytes = try test.compile()

            XCTAssertEqual(expectedType.hexa, bytes[0..<1].hexa)
            XCTAssertEqual(test.pairs.count, Int(bytes.readInt(bytes: 4, startIndex: 1) ?? -1))
            var start = 5
            for pair in test.pairs {
                if let key = pair.key as? Compilable {
                    let expected = try key.compile()
                    let current = Array(bytes[start..<(start + expected.count)])
                    XCTAssertEqual(current, expected)
                    start += expected.count
                } else {
                    XCTFail("Key: \(pair.key) is not compilable")
                }

                let expected = try pair.value.compile()
                let current = Array(bytes[start..<(start + expected.count)])
                XCTAssertEqual(current, expected)
                start += expected.count
            }
        }
    }

    func testHashDecompile() throws {
        let typeBytes = MonkeyTypes.hash.bytes
        let inner = try Hash(pairs: [:]).compile()

        // For some reason the swift compiler wasn't able to understand this
        // expression in a single line.
        var twoPairs = typeBytes + [0, 0, 0, 2]
        twoPairs.append(contentsOf: MString("a").compile())
        twoPairs.append(contentsOf: Integer(1).compile())
        twoPairs.append(contentsOf: MString("b").compile())
        twoPairs.append(contentsOf: Boolean.true.compile())

        let tests: [([Byte], Hash)] = [
            (typeBytes + [0, 0, 0, 0], Hash(pairs: [:])),
            (
                typeBytes + [0, 0, 0, 1] + Integer(0).compile() + Integer(1).compile(),
                Hash(pairs: [Integer(0): Integer(1)])
            ),
            (
                typeBytes + [0, 0, 0, 1] + MString("a").compile() + Integer(1).compile(),
                Hash(pairs: [MString("a"): Integer(1)])
            ),
            (
                twoPairs,
                Hash(pairs: [MString("a"): Integer(1), MString("b"): Boolean.true])
            ),
            (
                typeBytes + [0, 0, 0, 1] + MString("a").compile() + inner,
                Hash(pairs: [MString("a"): Hash(pairs: [:])])
            )
        ]

        for test in tests {
            let hash = try Hash(fromBytes: test.0)
            XCTAssert(test.1.isEquals(other: hash))
        }
    }

    func testFunctionCompile() throws {
        let tests: [CompiledFunction] = [
            CompiledFunction(instructions: [], localsCount: 0, parameterCount: 0),
            CompiledFunction(instructions: Bytecode.make(.return), localsCount: 10, parameterCount: 10)
        ]

        for test in tests {
            let expectedType = MonkeyTypes.function.rawValue

            let bytes = test.compile()

            XCTAssertEqual(expectedType.hexa, bytes[0..<1].hexa)
            XCTAssertEqual(test.parameterCount, Int(bytes.readInt(bytes: 4, startIndex: 1) ?? -1))
            XCTAssertEqual(test.localsCount, Int(bytes.readInt(bytes: 4, startIndex: 5) ?? -1))
            let instructionsCount = Int(bytes.readInt(bytes: 4, startIndex: 9) ?? -1)

            XCTAssertEqual(test.instructions.count, instructionsCount)

            if test.instructions.isEmpty {
                XCTAssert(bytes.count == 13)
            } else {
                XCTAssertEqual(test.instructions, Array(bytes[13...]))
            }
        }
    }

    func testFunctionDecompile() throws {
        let typeBytes = MonkeyTypes.function.bytes

        let tests: [([Byte], CompiledFunction)] = [
            (
                typeBytes + [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                CompiledFunction(instructions: [], localsCount: 0, parameterCount: 0)),
            (
                typeBytes + [0, 0, 0, 10, 0, 0, 0, 10, 0, 0, 0, 1] + Bytecode.make(.return),
                CompiledFunction(instructions: Bytecode.make(.return), localsCount: 10, parameterCount: 10)
            )
        ]

        for test in tests {
            let function = try CompiledFunction(fromBytes: test.0)
            XCTAssert(test.1.isEquals(other: function))
            XCTAssertEqual(test.1.localsCount, function.localsCount)
            XCTAssertEqual(test.1.parameterCount, function.parameterCount)
        }
    }

    func testDecompileTypeError() throws {
        typealias InitFunc = ([UInt8]) throws -> Object
        let tests: [(MonkeyTypes, InitFunc)] = [
            (MonkeyTypes.integer, Null.init),
            (MonkeyTypes.null, Integer.init),
            (MonkeyTypes.null, MFloat.init),
            (MonkeyTypes.null, Boolean.init),
            (MonkeyTypes.null, MString.init),
            (MonkeyTypes.null, MArray.init),
            (MonkeyTypes.null, Hash.init),
            (MonkeyTypes.null, CompiledFunction.init)
        ]

        for test in tests {
            do {
                let value = try test.1(test.0.bytes)
                XCTFail("This line should not be reached")
                XCTAssertNil(value)
            } catch let error as UnknowValueType {
                XCTAssertEqual("Unknow value type: \(test.0.bytes.hexa)", error.description)
            } catch {
                XCTFail("Unexpected Error")
            }
        }
    }
}
