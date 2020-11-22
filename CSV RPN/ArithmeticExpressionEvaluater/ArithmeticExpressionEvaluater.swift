//
//  ArithmeticExpressionEvaluater.swift
//  CSV RPN
//
//  Created by Srinivasan Dodda on 21.11.20.
//

import Foundation

protocol ArithmeticExpressionEvaluater {
    
    func evaluate(expression: ArithmeticExpression) -> ExpressionResult
    
}
