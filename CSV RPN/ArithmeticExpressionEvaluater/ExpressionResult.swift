//
//  ExpressionResult.swift
//  CSV RPN
//
//  Created by Srinivasan Dodda on 21.11.20.
//

import Foundation

enum ExpressionResult {
    
    case value(Float)
    case empty
    case error(ExpressionEvaluaterError)
    
}
