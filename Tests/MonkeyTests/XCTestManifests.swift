#if !canImport(ObjectiveC)
import XCTest

extension BuiltinFunctionsTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__BuiltinFunctionsTests = [
        ("testFirstFunction", testFirstFunction),
        ("testLastFunction", testLastFunction),
        ("testLenFunction", testLenFunction),
        ("testPushFunction", testPushFunction),
        ("testRestFunction", testRestFunction),
    ]
}

extension EvaluateOperationsTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__EvaluateOperationsTests = [
        ("testBangOperator", testBangOperator),
        ("testEvalBoolean", testEvalBoolean),
        ("testEvalInteger", testEvalInteger),
        ("testEvalStringCompare", testEvalStringCompare),
        ("testEvalStringConcatention", testEvalStringConcatention),
    ]
}

extension LexerTypesTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__LexerTypesTests = [
        ("testInvalidStrings", testInvalidStrings),
        ("testReadIdentifier", testReadIdentifier),
        ("testReadInteger", testReadInteger),
        ("testStrings", testStrings),
    ]
}

extension MonkeyCompilerTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MonkeyCompilerTests = [
        ("testArrayLiterals", testArrayLiterals),
        ("testBooleanExpressions", testBooleanExpressions),
        ("testConditionals", testConditionals),
        ("testFunctionCalls", testFunctionCalls),
        ("testFunctions", testFunctions),
        ("testGlobalLetStatements", testGlobalLetStatements),
        ("testGlobalVarStatements", testGlobalVarStatements),
        ("testHashLiterals", testHashLiterals),
        ("testIndexExpressions", testIndexExpressions),
        ("testIntegerArithmetic", testIntegerArithmetic),
        ("testStringExpressions", testStringExpressions),
    ]
}

extension MonkeyEvaluatorTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MonkeyEvaluatorTests = [
        ("testArrayIndexExpression", testArrayIndexExpression),
        ("testArrayLiteral", testArrayLiteral),
        ("testAssignStatement", testAssignStatement),
        ("testClousure", testClousure),
        ("testDeclareStatement", testDeclareStatement),
        ("testEvalComments", testEvalComments),
        ("testEvalStrings", testEvalStrings),
        ("testEvaluatorErrors", testEvaluatorErrors),
        ("testFunctionCall", testFunctionCall),
        ("testFunctionObject", testFunctionObject),
        ("testHashIndexExpressions", testHashIndexExpressions),
        ("testHashLiteral", testHashLiteral),
        ("testIfElseExpression", testIfElseExpression),
        ("testReturnStatement", testReturnStatement),
    ]
}

extension MonkeyLexerTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MonkeyLexerTests = [
        ("testNextToken", testNextToken),
        ("testNextTokenFromFile", testNextTokenFromFile),
        ("testNextTokenWithLineNumber", testNextTokenWithLineNumber),
    ]
}

extension MonkeyParserExpressionTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MonkeyParserExpressionTests = [
        ("testCallExpression", testCallExpression),
        ("testExpressions", testExpressions),
        ("testIdentifierExpression", testIdentifierExpression),
        ("testIfElseExpression", testIfElseExpression),
        ("testIfExpression", testIfExpression),
        ("testInfixExpressions", testInfixExpressions),
        ("testParsingIndexExpressions", testParsingIndexExpressions),
        ("testPrefixExpressions", testPrefixExpressions),
    ]
}

extension MonkeyParserStatementsTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MonkeyParserStatementsTests = [
        ("testParseAssignStatement", testParseAssignStatement),
        ("testParseLetStatement", testParseLetStatement),
        ("testParseLetStatementErrors", testParseLetStatementErrors),
        ("testParseVarStatement", testParseVarStatement),
        ("testReturnStatement", testReturnStatement),
    ]
}

extension ParseHashLiteralsTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ParseHashLiteralsTests = [
        ("testParsingEmptyHashLiteral", testParsingEmptyHashLiteral),
        ("testParsingHashLiteralWithBooleanKeys", testParsingHashLiteralWithBooleanKeys),
        ("testParsingHashLiteralWithIntegerKeys", testParsingHashLiteralWithIntegerKeys),
        ("testParsingHashLiteralWithStringKeys", testParsingHashLiteralWithStringKeys),
    ]
}

extension ParseLiteralsTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ParseLiteralsTests = [
        ("testArrayLiteral", testArrayLiteral),
        ("testBooleanLiteralExpression", testBooleanLiteralExpression),
        ("testComments", testComments),
        ("testFunctionLiteral", testFunctionLiteral),
        ("testIntLiteralExpression", testIntLiteralExpression),
        ("testStringLiteralExpression", testStringLiteralExpression),
    ]
}

extension VMTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__VMTests = [
        ("testArrayLiterals", testArrayLiterals),
        ("testBooleanExpressions", testBooleanExpressions),
        ("testCallingFunctionsWithoutArguments", testCallingFunctionsWithoutArguments),
        ("testCallingFunctionsWithoutReturnValue", testCallingFunctionsWithoutReturnValue),
        ("testCallingFunctionsWithReturnStatement", testCallingFunctionsWithReturnStatement),
        ("testConditionals", testConditionals),
        ("testFirstClassFunctions", testFirstClassFunctions),
        ("testGlobalLetStatements", testGlobalLetStatements),
        ("testGlobalVarStatements", testGlobalVarStatements),
        ("testHashLiterals", testHashLiterals),
        ("testIndexExpressions", testIndexExpressions),
        ("testIntegerArithmetic", testIntegerArithmetic),
        ("testStringExpressions", testStringExpressions),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BuiltinFunctionsTests.__allTests__BuiltinFunctionsTests),
        testCase(EvaluateOperationsTests.__allTests__EvaluateOperationsTests),
        testCase(LexerTypesTests.__allTests__LexerTypesTests),
        testCase(MonkeyCompilerTests.__allTests__MonkeyCompilerTests),
        testCase(MonkeyEvaluatorTests.__allTests__MonkeyEvaluatorTests),
        testCase(MonkeyLexerTests.__allTests__MonkeyLexerTests),
        testCase(MonkeyParserExpressionTests.__allTests__MonkeyParserExpressionTests),
        testCase(MonkeyParserStatementsTests.__allTests__MonkeyParserStatementsTests),
        testCase(ParseHashLiteralsTests.__allTests__ParseHashLiteralsTests),
        testCase(ParseLiteralsTests.__allTests__ParseLiteralsTests),
        testCase(VMTests.__allTests__VMTests),
    ]
}
#endif
