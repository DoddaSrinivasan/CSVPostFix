//
//  ArithmeticExpressionParser.swift
//  CSV RPN
//
//  Created by Srinivasan Dodda on 21.11.20.
//

import Foundation

class ArithmeticExpressionParser {
    
    let itemSeparator: Character
    
    init(itemSeparator: Character = " ") {
        self.itemSeparator = itemSeparator
    }
    
}

// MARK: - ArithmeticExpressionParserProtocol

extension ArithmeticExpressionParser: ArithmeticExpressionParserProtocol {
    
    func parse(expression: String) -> Result<ArithmeticExpression, ArithmeticExpressionError> {
        do{
            let items = try expression
                .split(separator: itemSeparator)
                .filter { !$0.isEmpty }
                .map { try ArithmeticExpression.Item(item: String($0)) }
            return .success(.init(expression: expression, items: items))
        } catch let error as ArithmeticExpressionError {
            return .failure(error)
        } catch {
            assert(false, "Unhandled expression parse error")
            return .failure(.unknown)
        }
    }
    
}

// MARK: Private

extension ArithmeticExpression.Item {
    
    init(item: String) throws {
        if let value = Float(item) {
            self = .operand(value: value)
            return
        }
        
        if let `operator` = ArithmeticOperator(rawValue: item) {
            self = .operator(`operator`)
            return
        }
        
        throw ArithmeticExpressionError.invalidItem(item)
    }
    
}

