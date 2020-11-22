//
//  Protocols.swift
//  CSV RPN
//
//  Created by Srinivasan Dodda on 22.11.20.
//

import Foundation

protocol CSVViewProtocol {
    
    func update(viewModel: CSVViewModel)
    
}

protocol CSVPresenterProtocol {
    
    func loadCSV()
    
}
