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
typealias Chessboard = [ChessboardRow]

struct ChessboardSquare: Hashable {
    
    var position = ChessboardSquarePosition()
    var mode = ChessboardSquareMode.white
    
    var description: String {
        return "Position: \(position.description), mode: \(mode)"
    }
    static func == (lhs: ChessboardSquare, rhs: ChessboardSquare) -> Bool {
        return lhs.position == rhs.position
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
    }
}

struct ChessboardSquarePosition: Hashable {
    let theRow: Int
    let theColumn: Int
    
    var description: String {
        return "Row: \(theRow + 1), Column: \(theColumn + 1)"
    }
    
    init() {
        theRow = 0
        theColumn = 0
    }
    
    init(row: Int, column: Int) {
        theRow = row
        theColumn = column
    }
    
    static func == (lhs: ChessboardSquarePosition, rhs: ChessboardSquarePosition) -> Bool {
        return lhs.theColumn == rhs.theColumn && lhs.theRow == rhs.theRow
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(theRow)
        hasher.combine(theColumn)
    }
}


class ChessboardHelper {
    func createChessboard(ofSize size: Int) -> Chessboard {
        var chessboard = Chessboard()
        
        for row in 0..<size {
            chessboard.append(self.createSquares(inRow: row, andChessboardSize: size))
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
