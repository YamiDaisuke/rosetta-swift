//
//  MonkeyInfixParser.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 18-01-21.
//

import Foundation
import Hermes

struct MonkeyInfixParser: InfixParser, MonkeyExpressionParser {
    func parse<P>(_ parser: inout P, lhs: Expression) throws -> Expression? where P: Parser {
        guard let token = parser.currentToken else {
            throw InvalidToken(parser.currentToken)
        }

        switch token.type {
        case Token.Kind.lparen:
            return try parseCallExpression(&parser, lhs: lhs)
        case Token.Kind.lbracket:
            return try parseIndexExpression(&parser, lhs: lhs)
        default:
            return try parseInfix(&parser, lhs: lhs)
        }
    }

    func parseInfix<P>(_ parser: inout P, lhs: Expression) throws -> Expression? where P: Parser {
        guard let token = parser.currentToken else {
            throw InvalidToken(parser.currentToken)
        }

        let precedence = parser.currentPrecendece
        parser.readToken()
        guard let rhs = try parser.parseExpression(withPrecedence: precedence) else {
            throw InvalidExpression(parser.currentToken)
        }

        return InfixExpression(token: token, lhs: lhs, operatorSymbol: token.literal, rhs: rhs)
    }

    func parseCallExpression<P>(_ parser: inout P, lhs: Expression) throws -> Expression? where P: Parser {
        guard let token = parser.currentToken, token.type == .lparen else {
            throw InvalidToken(parser.currentToken)
        }

        let args = try self.parseExpressionList(withEndDelimiter: .rparen, parser: &parser)
        return CallExpression(token: token, function: lhs, args: args)
    }

    func parseIndexExpression<P>(_ parser: inout P, lhs: Expression) throws -> Expression? where P: Parser {
        guard let token = parser.currentToken, token.type == .lbracket else {
            throw InvalidToken(parser.currentToken)
        }

        parser.readToken()
        guard let index = try parser.parseExpression(withPrecedence: MonkeyPrecedence.lowest.rawValue) else {
            throw InvalidExpression(parser.currentToken)
        }

        try parser.expectNext(toBe: .rbracket)
        return IndexExpression(token: token, lhs: lhs, index: index)
    }
}
