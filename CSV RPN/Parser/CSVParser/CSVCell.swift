//
//  CSVCell.swift
//  CSV RPN
//
//  Created by Srinivasan Dodda on 22.11.20.
//

import Foundation

enum NormalisingCellError: Error {
    case unNormalised
    case circularReference
    case unknown
}

enum NormalisedCellContent {
    case value(String)
    case error(NormalisingCellError)
}

struct CSVCell {
    
    var rawContent: String
    var normalisedContent: NormalisedCellContent
    
    
}
