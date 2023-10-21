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
    var type = ChessboardSquareType.none
    
    var description: String {
        return "Position: \(position.description), Type: \(type)"
    }
    
    init(position: ChessboardSquarePosition, color: ChessboardSquareColor, type: ChessboardSquareType) {
        self.position = position
        self.color = color
        self.type = type
    }
    
    init() {}
    
    static func == (lhs: ChessboardSquare, rhs: ChessboardSquare) -> Bool {
        return lhs.position == rhs.position
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
    }
}
