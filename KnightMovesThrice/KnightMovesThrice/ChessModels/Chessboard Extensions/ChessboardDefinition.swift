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
    
    func clearSolutionAndPath() {
        self.board.forEach({ chessRow in
            chessRow.forEach({ square in
                switch square.type {
                case .solutionStep(_), .pathStep:
                    square.type = .none
                default:
                    break
                }
            })
        })
    }
}
