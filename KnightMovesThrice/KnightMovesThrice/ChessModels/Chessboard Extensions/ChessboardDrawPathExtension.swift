//
//  ChessboardDrawPathExtension.swift
//  KnightMovesThrice
//
//  Created by  Dimitris Tasios Personal on 21/10/23.
//

import Foundation

// Get entire path used to reach each point
extension Chessboard {
    // adds combines the final points and the moves in order to get all intermediate squares
    func addIntermediatePointsToPath(with finalPoints: [ChessboardSquare], and moves: [KnightMove]) {
        for (index, move) in moves.enumerated() {
            
            let finalPoint = finalPoints[index] // moves are always n-1 for n points
            var finalPointPosition = finalPoint.position
            
            var moveDx = move.dx // assigned for mutability
            var moveDy = move.dy
            
            while moveDx != 0 { // we begin getting the intermediate squares by moving one by one in rows and then in column
                self.updateTheAdjastentSquare(from: &finalPointPosition,
                                                            and: &moveDx,
                                                            byRows: true)
            }
            
            while moveDy != 0 {
                self.updateTheAdjastentSquare(from: &finalPointPosition,
                                                            and: &moveDy,
                                                            byRows: false)
            }
        }
    }
    
    // the withinRow parameter determines if we're moving in the rows or columns axes
    private func updateTheAdjastentSquare(from squarePosition: inout ChessboardSquarePosition,
                                        and moveAmount: inout Int,
                                        byRows withinRow: Bool) {
        let nextSquare: ChessboardSquare
        
        if moveAmount > 0 {
            moveAmount -= 1
            
            if withinRow {
                nextSquare = self.board[squarePosition.row + 1][squarePosition.column]
            } else {
                nextSquare = self.board[squarePosition.row][squarePosition.column + 1]
            }
        } else {
            moveAmount += 1

            if withinRow {
                nextSquare = self.board[squarePosition.row - 1][squarePosition.column]
            } else {
                nextSquare = self.board[squarePosition.row][squarePosition.column - 1]
            }
        }
        
        switch nextSquare.type {
        case .none: // update only empty squares
            nextSquare.type = .pathStep
            squarePosition = nextSquare.position // update the position in order to check the next square
        default:
            break
        }
    }
}
