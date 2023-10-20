//
//  KnightHelper.swift
//  KnightMovesThrice
//
//  Created by  Dimitris Tasios Personal on 20/10/23.
//

import Foundation

struct ChessBoardSquare {
    let position = SquarePosition()
    let mode = SquareMode.white
    
    struct SquarePosition: Hashable {
        let x: Int
        let y: Int
        
        init() {
            x = 0
            y = 0
        }
    }
    
    enum SquareMode {
        case knight
        case goal
        case black
        case white
    }
}
