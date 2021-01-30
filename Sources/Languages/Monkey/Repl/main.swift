//
//  main.swift
//  rossetta
//
//  Created by Franklin Cruz on 27-12-20.
//

import Foundation
import Rosetta
import RosettaREPL
import MonkeyLang
import TSCUtility
import TSCBasic

do {
    let parser = ArgumentParser(
        commandName: "monkey",
        usage: "monkey [target_file]",
        overview: "The marvelous Monkey REPL and Interpreter"
    )

    let filename = parser.add(
        positional: "file",
        kind: String.self,
        optional: true,
        usage: "A file with Monkey code to be interpreted",
        completion: ShellCompletion.filename
    )

    let argsv = Array(CommandLine.arguments.dropFirst())
    let parguments = try parser.parse(argsv)
    var repl = MonkeyRepl()
    if let filename = parguments.get(filename) {
        var filepath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        filepath.appendPathComponent(filename)
        let environment = Environment<Object>()
        let lexer = MonkeyLexer(withFilePath: filepath)
        var monkeyParser = MonkeyParser(lexer: lexer)
        do {
            if let program = try monkeyParser.parseProgram() {
                _ = try MonkeyEvaluator.eval(program: program, environment: environment)
            } else {
                throw "Program not parsed"
            }
        } catch let error as AllParserError {
            TerminalController.printError(error)
        } catch {
            TerminalController.printError(error)
        }
    } else {
        repl.run()
    }
} catch let ArgumentParserError.expectedValue(value) {
    TerminalController.printError("Missing value for argument \(value).")
} catch let ArgumentParserError.expectedArguments(parser, stringArray) {
    TerminalController.printError("Parser: \(parser) Missing arguments: \(stringArray.joined()).")
} catch {
    TerminalController.printError(error.localizedDescription)
}
