//
//  CSVParserProtocol.swift
//  CSV RPN
//
//  Created by Srinivasan Dodda on 21.11.20.
//

import Foundation

protocol CSVParserProtocol {
    
    func parseFile(named name: String, type: String?, replacingEmptyCellWith replacingString: String) throws -> CSV
    
}
