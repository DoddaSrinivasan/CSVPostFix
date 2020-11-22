//
//  ArithmeticOperator+Evaluate.swift
//  CSV RPN
//
//  Created by Srinivasan Dodda on 21.11.20.
//

import Foundation

extension ArithmeticOperator {

    func evaluate(operand1: Float, operand2: Float) throws -> Float {
        switch self {
        case .add:
            return operand1 + operand2
        case .subtract:
            return operand1 - operand2
        case .multiply:
            return operand1 * operand2
        case .divide where operand2 != 0:
            return operand1 / operand2
        default:
            throw ExpressionEvaluaterError.divideByZero
        }
    }
    
}
