//
//  ArithmeticExpression.swift
//  CSV RPN
//
//  Created by Srinivasan Dodda on 21.11.20.
//

import Foundation

struct ArithmeticExpression {
    
    enum Item {
        
        case operand(value: Float)
        case `operator`(ArithmeticOperator)
        
    }
    
    var expression: String
    var items: [Item]
    
}
