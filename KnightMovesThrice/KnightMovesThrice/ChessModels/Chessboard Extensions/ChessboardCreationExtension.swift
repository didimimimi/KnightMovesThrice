//
//  ChessboardCreationExtension.swift
//  KnightMovesThrice
//
//  Created by  Dimitris Tasios Personal on 21/10/23.
//

import Foundation

// Creation of the chessboard
extension Chessboard {
    func createChessboard() {
        self.board = []
        
        for row in 0..<self.size {
            self.board.append(self.createSquares(inRow: row))
        }
    }
    
    private func createSquares(inRow row: Int) -> ChessboardRow {
        var squaresInRow = ChessboardRow()
        
        for column in 0..<self.size {
            let color: ChessboardSquareColor
            
            let isEvenRow = row % 2 == 0
            let isEvenColumn = column % 2 == 0
            
            if isEvenRow {
                if isEvenColumn {
                    color = .black
                } else {
                    color = .white
                }
            } else {
                if isEvenColumn {
                    color = .white
                } else {
                    color = .black
                }
            }
            
            let position = ChessboardSquarePosition(row: row, column: column)
            let chessSquare = ChessboardSquare(position: position, color: color, type: .none)
            squaresInRow.append(chessSquare)
        }
        
        return squaresInRow
    }
}
