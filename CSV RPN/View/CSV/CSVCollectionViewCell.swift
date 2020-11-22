//
//  CSVCollectionViewCell.swift
//  CSV RPN
//
//  Created by Srinivasan Dodda on 22.11.20.
//

import UIKit

class CSVCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var label: UILabel! {
        didSet {
            label.text = ""
        }
    }
    
    func set(viewModel: CSVCellViewModel) {
        label.text = viewModel.content
    }
    
}
