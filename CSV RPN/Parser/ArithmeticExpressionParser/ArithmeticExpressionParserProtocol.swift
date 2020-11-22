//
//  ArithmeticExpressionParserProtocol.swift
//  CSV RPN
//
//  Created by Srinivasan Dodda on 21.11.20.
//

import Foundation

protocol ArithmeticExpressionParserProtocol {
    
    func parse(expression: String) -> Result<ArithmeticExpression, ArithmeticExpressionError>
    
}
