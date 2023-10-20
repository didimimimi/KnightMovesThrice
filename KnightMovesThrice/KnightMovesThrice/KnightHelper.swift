//
//  KnightHelper.swift
//  KnightMovesThrice
//
//  Created by  Dimitris Tasios Personal on 20/10/23.
//

import Foundation

class ChessBoardSquare: Hashable {
    
    var position = SquarePosition()
    var mode = SquareMode.white
    
    static func == (lhs: ChessBoardSquare, rhs: ChessBoardSquare) -> Bool {
        return lhs.position == rhs.position
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
    }

    class SquarePosition: Hashable {
        let x: Int
        let y: Int
        
        init() {
            x = 0
            y = 0
        }
        
        static func == (lhs: ChessBoardSquare.SquarePosition, rhs: ChessBoardSquare.SquarePosition) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(x)
            hasher.combine(y)
        }
    }
    
    enum SquareMode {
        case knight
        case goal
        case black
        case white
    }
}
