//
//  ChessboardThreeMovesExtension.swift
//  KnightMovesThrice
//
//  Created by  Dimitris Tasios Personal on 21/10/23.
//

import Foundation

// Find the 3 moves from the starting position to the goal
extension Chessboard {
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
}
