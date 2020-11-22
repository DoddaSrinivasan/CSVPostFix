//
//  ArithmeticExpressionError.swift
//  CSV RPN
//
//  Created by Srinivasan Dodda on 21.11.20.
//

import Foundation

enum ArithmeticExpressionError: Error {
    
    case invalidItem(String)
    case unknown
    
}
