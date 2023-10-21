//
//  ChessboardMainViewModel.swift
//  KnightMovesThrice
//
//  Created by  Dimitris Tasios Personal on 21/10/23.
//

import Foundation

protocol ChessboardMainViewModelDelegate: AnyObject {
    func update(state: ChessboardMainStates)
}

class ChessboardMainViewModel: ChessboardMainIntents {
    
    private var chessboard = Chessboard(size: 8)
    private var mode = ChessboardSquareMode.knight
    
    private weak var delegate: ChessboardMainViewModelDelegate?
    
    init(delegate: ChessboardMainViewModelDelegate) {
        self.delegate = delegate
        self.delegate?.update(state: .newChessboardState(chessboard: self.chessboard))
    }
    
    init() {}
    
    func squareTapped(square: ChessboardSquare) {
        square.mode = self.mode

        self.delegate?.update(state: .newSquareState(square: square))
    }
    
    func sliderDragged(to value: Float) {
        let roundedValue = lroundf(value)
        self.chessboard.size = roundedValue
        
        self.delegate?.update(state: .sliderValueChangedState(value: Float(roundedValue)))
        self.delegate?.update(state: .newChessboardState(chessboard: self.chessboard))
    }
    
    func switchToogled(to value: Bool) {
        self.mode = value ? .goal : .knight        
    }
    
    func findPathButtonTapped() {
        
    }
    
    func resetButtonTapped() {
        self.chessboard.size = self.chessboard.size // setting the size will redraw the chessboard
        self.delegate?.update(state: .newChessboardState(chessboard: self.chessboard))
    }
}
