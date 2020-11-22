//
//  CSVParser.swift
//  CSV RPN
//
//  Created by Srinivasan Dodda on 21.11.20.
//

import Foundation

class CSVParser {
    
    let columnIdentifiers = Array("abcdefghijklmnopqrstuvwxyz".lowercased())
    let rowSeparator: Character
    let columnSeparator: Character
    
    init(rowSeparator: Character, columnSeparator: Character) {
        self.rowSeparator = rowSeparator
        self.columnSeparator = columnSeparator
    }
    
}

// MARK: - CSVParserProtocol

extension CSVParser: CSVParserProtocol {
    
    func parseFile(named name: String, type: String?, replacingEmptyCellWith replacingString: String) throws -> CSV {
        guard let path = Bundle.main.path(forResource: name, ofType: nil),
              let contents = try? String(contentsOfFile: path) else {
            throw CSVParserError.fileNotFound(name: name, type: type)
        }
        
        var items = contents
            .split(separator: rowSeparator)
            .map {
                $0.split(separator: columnSeparator).map {
                    NormalisableContent(rawContent: $0.isEmpty ? replacingString : String($0))
                }
            }
        
        let normalisedItems: [[CSVCell]] = items.enumerated().map { enumeratedRow in
            return enumeratedRow.element.enumerated().map { enumeratedItem in
                let row = enumeratedRow.offset
                let column = enumeratedItem.offset
                normaliseItemInItems(&items, row: row, column: column)
                let item = items[row][column]
                return CSVCell(rawContent: item.rawContent, normalisedContent: item.normalisedContent)
            }
        }
        
        return CSV(items: normalisedItems)
    }
    
}

// MARK: - Private

private extension CSVParser {
    
    func normaliseItemInItems(_ items: inout [[NormalisableContent]], row: Int, column: Int) {
        var cell = items[row][column]
        
        switch cell.state {
        case .normalised:
            return
        case .normalising:
            cell.update(normalisedContent: .error(.circularReference))
            cell.update(state: .normalised)
            items[row][column] = cell
            return
        case .initial:
            break
        }
        
        cell.update(state: .normalising)
        items[row][column] = cell
        
        var normalisedElements: [String] = []
        
        do {
            try cell.rawContent.split(separator: " ").forEach { rawElement in
                switch CellElement(string: String(rawElement)) {
                case .text(let value):
                    normalisedElements.append(value.trimmingCharacters(in: .whitespacesAndNewlines))
                case .reference(let row, let column):
                    self.normaliseItemInItems(&items, row: row, column: column)
                    switch items[row][column].normalisedContent {
                    case .value(let value):
                        normalisedElements.append(value)
                    case .error(let error):
                        throw error
                    }
                }
            }
            cell.update(normalisedContent: .value(normalisedElements.joined(separator: " ")))
        } catch {
            let normalisationError = (error as? NormalisingCellError) ?? .unknown
            cell.update(normalisedContent: .error(normalisationError))
        }
        
        cell.update(state: .normalised)
        items[row][column] = cell
    }
}

// MARK: - Utils

private struct NormalisableContent {
    
    enum NormalisationState: Equatable {
        
        case initial
        case normalising
        case normalised
        
    }
    
    let rawContent: String
    var state: NormalisationState = .initial
    var normalisedContent: NormalisedCellContent = .error(.unNormalised)
    
    init(rawContent: String) {
        self.rawContent = rawContent
    }
    
    mutating func update(state: NormalisationState) {
        self.state = state
    }
    
    mutating func update(normalisedContent: NormalisedCellContent) {
        self.normalisedContent = normalisedContent
    }
}

private enum CellElement {
    
    case text(value: String)
    case reference(row: Int, column: Int)
    
    init(string: String) {
        if let reference = string.cellReference {
            self = .reference(row: reference.row, column: reference.column)
        } else {
            self = .text(value: string)
        }
    }
    
}

private extension String {
    
    private static let CELL_REFERENCE_PATTERN = "\\b[a-z]\\d+\\b"
    private static let COLUMN_IDENTIFIERS = Array("abcdefghijklmnopqrstuvwxyz")
    
    var cellReference: (row: Int, column: Int)? {
        let string = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let range = NSRange(location: 0, length: string.utf16.count)
        let regex = try! NSRegularExpression(pattern: String.CELL_REFERENCE_PATTERN)
        
        guard !regex.matches(in: string, options: [], range: range).isEmpty else {
            return nil
        }
        
        let columnIdentfier = Array(string)[0]
        
        guard let column = String.COLUMN_IDENTIFIERS.firstIndex(of: columnIdentfier),
              let row = Int(string.suffix(string.count - 1)) else {
            return nil
        }
        
        return (row, Int(column))
    }
    
}
