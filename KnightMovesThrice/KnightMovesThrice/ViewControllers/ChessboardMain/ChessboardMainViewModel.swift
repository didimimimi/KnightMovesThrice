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
    private var mode = ChessboardSpecialSquareMode.knight
    
    private var currentKnightSquare = ChessboardSquare()
    private var currentGoalSquare = ChessboardSquare()
    
    private weak var delegate: ChessboardMainViewModelDelegate?
    
    init(delegate: ChessboardMainViewModelDelegate) {
        self.delegate = delegate
        self.delegate?.update(state: .newChessboardState(chessboard: self.chessboard))
    }
    
    init() {}
    
    func squareTapped(square: ChessboardSquare) {
        var oldSquare = ChessboardSquare()
        
        switch self.mode {
        case .knight:
            let currentKnightPosition = self.currentKnightSquare.position
            self.chessboard.board[currentKnightPosition.row][currentKnightPosition.column].mode = .none
            
            square.mode = .knight
            
            oldSquare = currentKnightSquare
            self.currentKnightSquare = square
        case .goal:
            let currentGoalPosition = self.currentGoalSquare.position
            self.chessboard.board[currentGoalPosition.row][currentGoalPosition.column].mode = .none
            
            square.mode = .goal
            
            oldSquare = currentGoalSquare
            self.currentGoalSquare = square
        default:
            break
        }

        self.delegate?.update(state: .newSquareState(newSquare: square, oldSquare: oldSquare))
    }
    
    func sliderDragged(to value: Float) {
        let roundedValue = lroundf(value)
        self.chessboard.size = roundedValue
        self.resetSpecialCurrentSquares()
        
        self.delegate?.update(state: .sliderValueChangedState(value: Float(roundedValue)))
        self.delegate?.update(state: .newChessboardState(chessboard: self.chessboard))
    }
    
    func switchToogled(to value: Bool) {
        self.mode = value ? .goal : .knight        
    }
    
    func findPathButtonTapped() {
        guard let path = self.chessboard.findThreeMovesPath(from: self.currentKnightSquare, to: self.currentGoalSquare) else {
            self.delegate?.update(state: .noPathState)
            return
        }
        
        var stepCounter = 1
        
        path.forEach({ stepSquare in
            switch stepSquare.mode {
            case .none:
                let stepSquarePosition = stepSquare.position
                self.chessboard.board[stepSquarePosition.row][stepSquarePosition.column].mode = .solutionStep(title: "\(stepCounter)")
                stepCounter += 1
            default:
                break
            }
        })
        self.delegate?.update(state: .newChessboardState(chessboard: self.chessboard))
    }
    
    func resetButtonTapped() {
        self.chessboard.size = self.chessboard.size // setting the size will redraw the chessboard
        self.resetSpecialCurrentSquares()
        
        self.delegate?.update(state: .newChessboardState(chessboard: self.chessboard))
    }
    
    private func resetSpecialCurrentSquares() {
        self.currentKnightSquare = ChessboardSquare()
        self.currentGoalSquare = ChessboardSquare()
    }
}
