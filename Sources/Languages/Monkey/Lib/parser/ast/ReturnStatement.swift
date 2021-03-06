//
//  ReturnStatement.swift
//  Hermes
//
//  Created by Franklin Cruz on 02-01-21.
//

import Foundation
import Hermes

struct ReturnStatement: Statement {
    var token: Token
    var value: Expression

    var description: String {
        "\(token.literal) \(value);"
    }
}
