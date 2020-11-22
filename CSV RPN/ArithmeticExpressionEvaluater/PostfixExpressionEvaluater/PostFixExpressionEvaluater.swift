//
//  PostFixExpressionEvaluater.swift
//  CSV RPN
//
//  Created by Srinivasan Dodda on 21.11.20.
//

import Foundation

class PostFixExpressionEvaluater: ArithmeticExpressionEvaluater {
    
    func evaluate(expression: ArithmeticExpression) -> ExpressionResult {
        guard !expression.items.isEmpty else {
            return .empty
        }
        
        var operandsStack: [Float] = []
        
        do {
            try expression.items.forEach { item in
                switch item {
                case .operand(let value):
                    operandsStack.append(value)
                case .operator(let `operator`):
                    guard let operand2 = operandsStack.popLast(),
                          let operand1 = operandsStack.popLast() else {
                        throw ExpressionEvaluaterError.invalidFormat
                    }
                    
                    operandsStack.append(try `operator`.evaluate(operand1: operand1, operand2: operand2))
                }
            }
        } catch let error as ExpressionEvaluaterError {
            return .error(error)
        } catch {
            return .error(.unknown)
        }
        
        guard let value = operandsStack.first,
              operandsStack.count == 1 else {
            return .error(.unknown)
        }
        
        return .value(value)
    }
    
}
