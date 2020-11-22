//
//  CSVViewModel.swift
//  CSV RPN
//
//  Created by Srinivasan Dodda on 22.11.20.
//

import Foundation

enum CSVViewModel {
    
    case data([[CSVCellViewModel]])
    case error(String)
    
}

struct CSVCellViewModel {
    
    var content: String
    
}
