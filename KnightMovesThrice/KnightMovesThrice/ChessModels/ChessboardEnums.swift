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

enum ChessboardSquareType: Equatable {
    case knight
    case goal
    case solutionStep(title: String)
    case pathStep1
    case pathStep2
    case pathStep3
    case none
}

enum ChessboardMode {
    case placeKnight
    case placeGoal
}
