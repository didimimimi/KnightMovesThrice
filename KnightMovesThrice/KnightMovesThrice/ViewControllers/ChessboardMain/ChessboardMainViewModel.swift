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
    private var mode = ChessboardMode.placeKnight
    
    private weak var delegate: ChessboardMainViewModelDelegate?
    
    init(delegate: ChessboardMainViewModelDelegate) {
        self.delegate = delegate
        self.delegate?.update(state: .newChessboardState(chessboard: self.chessboard))
    }
    
    init() {}
    
    func squareTapped(square: ChessboardSquare) {
        self.clearOldSolution()
        
        var oldSquare: ChessboardSquare?
        
        if self.mode == .placeKnight {
            if let currentKnightSquare = self.chessboard.getKnightOnBoard() {
                oldSquare = currentKnightSquare
                
                let knightPosition = currentKnightSquare.position
                self.chessboard.board[knightPosition.row][knightPosition.column].type = .none
            }
            
            square.type = .knight
        } else {
            if let currentGoalSquare = self.chessboard.getGoalOnBoard() {
                oldSquare = currentGoalSquare
                
                let goalPosition = currentGoalSquare.position
                self.chessboard.board[goalPosition.row][goalPosition.column].type = .none
            }
            
            square.type = .goal
        }
        
        self.delegate?.update(state: .newSquareState(newSquare: square, oldSquare: oldSquare))
    }
    
    func sliderDragged(to value: Float) {
        let roundedValue = lroundf(value)
        self.chessboard.size = roundedValue
        
        self.delegate?.update(state: .sliderValueChangedState(value: Float(roundedValue)))
        self.delegate?.update(state: .newChessboardState(chessboard: self.chessboard))
    }
    
    func switchToogled(to value: Bool) {
        self.mode = value ? .placeGoal : .placeKnight
    }
    
    func findPathButtonTapped() {
        self.clearOldSolution()

        guard let knightOnBoard = self.chessboard.getKnightOnBoard(),
              let goalOnBoard = self.chessboard.getGoalOnBoard(),
              let finalPointsAndMoves = self.chessboard.findThreeMovesPath(from: knightOnBoard,
                                                                           to: goalOnBoard) else {
            self.delegate?.update(state: .noPathState)
            return
        }
        
        var stepCounter = 1
        
        finalPointsAndMoves.finalPoints.forEach({ stepSquare in
            switch stepSquare.type {
            case .none:
                let stepSquarePosition = stepSquare.position
                self.chessboard.board[stepSquarePosition.row][stepSquarePosition.column].type = .solutionStep(title: "\(stepCounter)")
                stepCounter += 1
            default:
                break
            }
        })
        
        self.chessboard.addIntermediatePointsToPath(with: finalPointsAndMoves.finalPoints, and: finalPointsAndMoves.moves)
        self.resetToKnightMode()
        self.delegate?.update(state: .newChessboardState(chessboard: self.chessboard))
    }
    
    func resetButtonTapped() {
        self.chessboard.size = self.chessboard.size // setting the size will redraw the chessboard
        
        self.resetToKnightMode()
        self.delegate?.update(state: .newChessboardState(chessboard: self.chessboard))
    }
    
    private func clearOldSolution() {
        self.chessboard.clearSolutionAndPath()

        // update to remove old solution
        self.delegate?.update(state: .newChessboardState(chessboard: self.chessboard))
    }
    
    private func resetToKnightMode() {
        self.mode = .placeKnight
        self.delegate?.update(state: .resetSwitchState)
    }
}
