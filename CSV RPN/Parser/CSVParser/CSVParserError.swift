//
//  CSVParserError.swift
//  CSV RPN
//
//  Created by Srinivasan Dodda on 21.11.20.
//

import Foundation

enum CSVParserError: Error {
    case fileNotFound(name: String, type: String?)
    case columnsLimitExceeded(row: Int)
}
