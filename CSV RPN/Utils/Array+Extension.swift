//
//  Array+Extension.swift
//  CSV RPN
//
//  Created by Srinivasan Dodda on 21.11.20.
//

import Foundation

extension Array {
    
    func get(index: Int) -> Element? {
        guard index < count else {
            return nil
        }
        
        return self[index]
    }
    
}
