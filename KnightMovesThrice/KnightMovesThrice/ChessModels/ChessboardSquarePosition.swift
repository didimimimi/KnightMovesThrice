//
//  ChessboardSquarePosition.swift
//  KnightMovesThrice
//
//  Created by  Dimitris Tasios Personal on 21/10/23.
//

import Foundation

class ChessboardSquarePosition: Hashable {
    let row: Int
    let column: Int
    
    var description: String {
        return "Row: \(row + 1), Column: \(column + 1)"
    }
    
    init() {
        row = 0
        column = 0
    }
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
    
    static func == (lhs: ChessboardSquarePosition, rhs: ChessboardSquarePosition) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }
}
