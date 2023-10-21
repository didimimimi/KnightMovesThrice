//
//  ChessboardMainIntent.swift
//  KnightMovesThrice
//
//  Created by  Dimitris Tasios Personal on 21/10/23.
//

import Foundation

protocol ChessboardMainIntents {
    func squareTapped(square: ChessboardSquare)
    func sliderDragged(to value: Float)
    func switchToogled(to value: Bool)
    func findPathButtonTapped()
    func resetButtonTapped()
}
