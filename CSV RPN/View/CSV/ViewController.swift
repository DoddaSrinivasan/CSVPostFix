//
//  ViewController.swift
//  CSV RPN
//
//  Created by Srinivasan Dodda on 21.11.20.
//

import UIKit

class ViewController: UIViewController {
    
    private struct Constants {
        static let cellWidth: CGFloat = 100
        static let cellHeight: CGFloat = 50
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private lazy var presenter: CSVPresenterProtocol = {
        return CSVPresenter(csvView: self)
    }()
    
    private var csvCellViewModels: [[CSVCellViewModel]]? {
        didSet {
            collectionView.collectionViewLayout = generateSpreadSheetLayout(noOfRows: noOfRows, noOfColumns: noOfColumns)
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.loadCSV()
    }
    
}

// MARK: - CSVViewProtocol

extension ViewController: CSVViewProtocol {
    
    func update(viewModel: CSVViewModel) {
        switch viewModel {
        case .data(let items):
            self.csvCellViewModels = items
        case .error(let message):
            self.csvCellViewModels = nil
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
    
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noOfRows * noOfColumns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CSVCollectionViewCell", for: indexPath)
        
        let viewModel = cellViewModel(at: indexPath.item)
        (cell as? CSVCollectionViewCell)?.set(viewModel: viewModel)
        
        return cell
    }
    
}

// MARK: - Private

extension ViewController {
    
    var noOfRows: Int {
        return csvCellViewModels?.count ?? 0
    }
    
    var noOfColumns: Int {
        return (csvCellViewModels ?? []).map { $0.count }.max() ?? 0
    }
    
    func cellViewModel(at index: Int) -> CSVCellViewModel {
        guard noOfColumns > 0 else {
            return .init(content: "")
        }
        
        let row = index / noOfColumns
        let column = index % noOfColumns
        
        return csvCellViewModels?.get(index: row)?.get(index: column) ?? .init(content: "")
    }
    
    func reloadData() {
        
    }
    
    func generateSpreadSheetLayout(noOfRows: Int, noOfColumns: Int) -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(Constants.cellWidth),
            heightDimension: .absolute(Constants.cellHeight))
        let csvCell = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(CGFloat(noOfColumns) * Constants.cellWidth),
            heightDimension: .absolute(Constants.cellHeight))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: csvCell,
            count: noOfColumns)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
