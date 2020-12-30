//
//  Tokens.swift
//  rossetta
//
//  Created by Franklin Cruz on 28-12-20.
//

import Foundation

// Special
extension Token.Kind {
    static let ilegal = Token.Kind("ilegal")
    static let eof = Token.Kind("eof")
}

// Identifiers and literals
extension Token.Kind {
    static let identifier = Token.Kind("identifier")
    static let int = Token.Kind("int")
}

// Operators
extension Token.Kind {
    static let assign = Token.Kind("=")
    static let equals = Token.Kind("==")
    static let plus = Token.Kind("+")
    static let minus = Token.Kind("-")
    static let bang = Token.Kind("!")
    static let notEquals = Token.Kind("!=")
    static let asterisk = Token.Kind("*")
    static let slash = Token.Kind("/")
    static let lt = Token.Kind("<")
    static let lte = Token.Kind("<=")
    static let gt = Token.Kind(">")
    static let gte = Token.Kind(">=")
}

// Delimiters
extension Token.Kind {
    static let comma = Token.Kind(",")
    static let semicolon = Token.Kind(";")
    
    static let lparen = Token.Kind("(")
    static let rparen = Token.Kind(")")
    static let lbrace = Token.Kind("{")
    static let rbrace = Token.Kind("}")
}

// Keywords
extension Token.Kind {
    static let function = Token.Kind("fn")
    static let `let` = Token.Kind("let")
    static let `true` = Token.Kind("true")
    static let `false` = Token.Kind("false")
    static let `if` = Token.Kind("if")
    static let `else` = Token.Kind("else")
    static let `return` = Token.Kind("return")
    
    static var keywords: Set<Token.Kind> {
        [.function, .let, .true, .false, .if, .else, .return]
    }
}