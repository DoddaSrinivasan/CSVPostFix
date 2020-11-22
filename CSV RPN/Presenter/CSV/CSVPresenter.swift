//
//  CSVPresenter.swift
//  CSV RPN
//
//  Created by Srinivasan Dodda on 22.11.20.
//

import Foundation

class CSVPresenter {
    
    let csvView: CSVViewProtocol
    let csvParser: CSVParserProtocol
    let expressionParser: ArithmeticExpressionParserProtocol
    let expressionEvaluater: ArithmeticExpressionEvaluater
    
    init(csvView: CSVViewProtocol,
         csvParser: CSVParserProtocol,
         expressionParser: ArithmeticExpressionParserProtocol,
         expressionEvaluater: ArithmeticExpressionEvaluater) {
        self.csvView = csvView
        self.csvParser = csvParser
        self.expressionParser = expressionParser
        self.expressionEvaluater = expressionEvaluater
    }
    
    convenience init(csvView: CSVViewProtocol) {
        self.init(csvView: csvView,
                  csvParser: CSVParser(rowSeparator: "\n", columnSeparator: ","),
                  expressionParser: ArithmeticExpressionParser(),
                  expressionEvaluater: PostFixExpressionEvaluater())
    }
    
}

// MARK: - CSVPresenterProtocol

extension CSVPresenter: CSVPresenterProtocol {
    
    func loadCSV() {
        do {
            let csv = try csvParser.parseFile(named: "rpn-csv", type: nil, replacingEmptyCellWith: "0")
            let csvCellViewModels = csv.items.map { row in
                return row.map { item in
                    return self.viewModel(for: item)
                }
            }
            csvView.update(viewModel: .data(csvCellViewModels))
        } catch {
            csvView.update(viewModel: .error(error.localizedDescription))
        }
    }
    
}

// MARK: - Private

extension CSVPresenter {
    
    func viewModel(for item: CSVCell) -> CSVCellViewModel {
        let expressionParser = ArithmeticExpressionParser()
        let expressionEvaluater = PostFixExpressionEvaluater()
        
        guard case .value(let expressionString) = item.normalisedContent else {
            return .init(content: "ERR")
        }
        
        let expressionResult = expressionParser.parse(expression: expressionString)
        switch expressionResult {
        case .success(let expression):
            switch expressionEvaluater.evaluate(expression: expression) {
            case .empty:
                return .init(content: "0")
            case .value(let value):
                return .init(content: "\(value)")
            case .error:
                return .init(content: "ERR")
            }
        case .failure:
            return .init(content: "ERR")
        }
    }
    
}


// MARK: - Utils

private extension NormalisedCellContent {
    
    var error: NormalisingCellError? {
        guard case .error(let error) = self else {
            return nil
        }
        
        return error
    }
    
}
