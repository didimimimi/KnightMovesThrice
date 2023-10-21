//
//  ChessEnums.swift
//  KnightMovesThrice
//
//  Created by  Dimitris Tasios Personal on 21/10/23.
//

import Foundation

enum ChessboardSquareColor {
    case black
    case white
}

enum ChessboardSquareType {
    case knight
    case goal
    case solutionStep(title: String)
    case pathStep
    case none
}
