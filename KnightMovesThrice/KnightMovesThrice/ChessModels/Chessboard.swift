//
//  KnightHelper.swift
//  KnightMovesThrice
//
//  Created by  Dimitris Tasios Personal on 20/10/23.
//

import Foundation

typealias ChessboardRow = [ChessboardSquare]
typealias KnightMove = (dx: Int, dy: Int)

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
    
    private func isWithinValidBounds(row: Int, column: Int) -> Bool {
        let validBounds = 0..<self.size
        return validBounds.contains(row) && validBounds.contains(column)
    }
    
    private func getKnightMoves() -> [KnightMove] {
        return [
            KnightMove(dx: 2, dy: 1),
            KnightMove(dx: 2, dy: -1),
            KnightMove(dx: 1, dy: 2),
            KnightMove(dx: 1, dy: -2),
            KnightMove(dx: -2, dy: 1),
            KnightMove(dx: -2, dy: -1),
            KnightMove(dx: -1, dy: 2),
            KnightMove(dx: -1, dy: -2)
        ]
    }
    
    func findThreeMovesPath(from knightSquare: ChessboardSquare,
                            to goalSquare: ChessboardSquare) -> (finalPoints: [ChessboardSquare], moves: [KnightMove])? {
        let knightMoves = self.getKnightMoves() // the available moves for the knight
        
        var visited = Set<ChessboardSquare>() // squares we have already visited
        var queue = [
            (
                knightSquare,
                [knightSquare],
                [KnightMove(dx: 0, dy: 0)]
            )
        ]   // Each queue item includes the position, the path to reach that position as well as all the moves in the path.
        // Starts from knight's initial position
        
        for _ in 0..<3 {
            var nextQueue = [
                (
                    ChessboardSquare,
                    [ChessboardSquare],
                    [KnightMove]
                )
            ]() // holds all items for the nth move
            
            while !queue.isEmpty {
                let (current, path, moves) = queue.removeFirst() // examine a current square
                
                for (dx, dy) in knightMoves {
                    let newRow = current.position.row + dx
                    let newColumn = current.position.column + dy // move the knight to the next square
                    
                    if isWithinValidBounds(row: newRow, column: newColumn) { // if we're within the chessboard's bounds
                        let nextPoint = self.board[newRow][newColumn]
                        
                        if !visited.contains(nextPoint) {
                            if nextPoint == goalSquare {
                                // The destination is reachable, return the full path.
                                //  The first move is the knight's initial position so it's removed for clarity
                                var finalMoves = moves + [KnightMove(dx: dx, dy: dy)]
                                finalMoves.removeFirst()
                                
                                return (finalPoints: path + [nextPoint], moves: finalMoves)
                            }
                            
                            visited.insert(nextPoint) // mark as visited
                            
                            // prepare next level of moves in the BFS algorithm
                            // E.g all possible moves for the first move, etc.
                            nextQueue.append((nextPoint, path + [nextPoint], moves + [KnightMove(dx: dx, dy: dy)]))
                        }
                    }
                }
            }
            queue = nextQueue // begin searching the next level of moves
        }
        
        // If no solution is found, return nil.
        return nil
    }
    
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
