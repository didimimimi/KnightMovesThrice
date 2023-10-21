//
//  KnightHelper.swift
//  KnightMovesThrice
//
//  Created by  Dimitris Tasios Personal on 20/10/23.
//

import Foundation

enum ChessboardSquareColor {
    case black
    case white
}

enum ChessboardSpecialSquareMode {
    case knight
    case goal
    case none
}

typealias ChessboardRow = [ChessboardSquare]

class Chessboard {
    var board = [ChessboardRow]()
    var size: Int {
        didSet {
            self.createChessboard()
        }
    }
    
    init(size: Int) {
        self.size = size
        self.createChessboard()
    }
    
    init() {
        self.size = 0
    }
    
    private func createChessboard() {
        self.board = []
        
        for row in 0..<self.size {
            self.board.append(self.createSquares(inRow: row))
        }
    }
    
    private func createSquares(inRow row: Int) -> ChessboardRow {
        var squaresInRow = ChessboardRow()
        
        for column in 0..<self.size {
            let color: ChessboardSquareColor
            
            if row % 2 == 0 {
                if column % 2 == 0 {
                    color = .black
                } else {
                    color = .white
                }
            } else {
                if column % 2 == 0 {
                    color = .white
                } else {
                    color = .black
                }
            }
            
            let position = ChessboardSquarePosition(row: row, column: column)
            let chessSquare = ChessboardSquare(position: position, color: color, mode: .none)
            squaresInRow.append(chessSquare)
        }
        
        return squaresInRow
    }
    
    func getOriginalColor(of square: ChessboardSquare) {
        
    }
}

class ChessboardSquare: Hashable {
    
    var position = ChessboardSquarePosition()
    var color = ChessboardSquareColor.white
    var mode = ChessboardSpecialSquareMode.none
    
    var description: String {
        return "Position: \(position.description), Mode: \(mode)"
    }
    
    init(position: ChessboardSquarePosition, color: ChessboardSquareColor, mode: ChessboardSpecialSquareMode) {
        self.position = position
        self.color = color
        self.mode = mode
    }
    
    init() {}
    
    static func == (lhs: ChessboardSquare, rhs: ChessboardSquare) -> Bool {
        return lhs.position == rhs.position
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
    }
}

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
