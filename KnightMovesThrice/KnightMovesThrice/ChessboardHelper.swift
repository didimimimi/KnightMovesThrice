//
//  KnightHelper.swift
//  KnightMovesThrice
//
//  Created by  Dimitris Tasios Personal on 20/10/23.
//

import Foundation

enum ChessboardSquareMode {
    case knight
    case goal
    case black
    case white
}

typealias ChessboardRow = [ChessboardSquare]

struct Chessboard {
    var board = [ChessboardRow]()
    var size: Int
    
    init(size: Int = 8) {
        self.size = size
    }
}

class ChessboardSquare: Hashable {
    
    var position = ChessboardSquarePosition()
    var mode = ChessboardSquareMode.white
    
    var description: String {
        return "Position: \(position.description), Mode: \(mode)"
    }
    
    init(position: ChessboardSquarePosition, mode: ChessboardSquareMode) {
        self.position = position
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


class ChessboardHelper {
    func createChessboard(ofSize size: Int) -> Chessboard {
        var chessboard = Chessboard(size: size)
        
        for row in 0..<chessboard.size {
            chessboard.board.append(self.createSquares(inRow: row, andChessboardSize: size))
        }
        
        return chessboard
    }
    
    private func createSquares(inRow row: Int, andChessboardSize size: Int) -> ChessboardRow {
        var squaresInRow = ChessboardRow()
        
        for column in 0..<size {
            let mode: ChessboardSquareMode
            if row % 2 == 0 {
                if column % 2 == 0 {
                    mode = .black
                } else {
                    mode = .white
                }
            } else {
                if column % 2 == 0 {
                    mode = .white
                } else {
                    mode = .black
                }
            }
            
            let position = ChessboardSquarePosition(row: row, column: column)
            let chessSquare = ChessboardSquare(position: position, mode: mode)
            squaresInRow.append(chessSquare)
        }
        
        return squaresInRow
    }
}
