//
//  ChessboardSquare.swift
//  KnightMovesThrice
//
//  Created by  Dimitris Tasios Personal on 21/10/23.
//

import Foundation

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
