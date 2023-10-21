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
    
    private var currentKnightSquare = ChessboardSquare(position: ChessboardSquarePosition(), color: .white, type: .knight)
    private var currentGoalSquare = ChessboardSquare(position: ChessboardSquarePosition(), color: .white, type: .goal)
    
    private weak var delegate: ChessboardMainViewModelDelegate?
    
    init(delegate: ChessboardMainViewModelDelegate) {
        self.delegate = delegate
        self.delegate?.update(state: .newChessboardState(chessboard: self.chessboard))
    }
    
    init() {}
    
    func squareTapped(square: ChessboardSquare) {
        self.chessboard.clearSolutionAndPath()

        // update to remove old solution
        self.delegate?.update(state: .newChessboardState(chessboard: self.chessboard))

        var newSquare = square
        var oldSquare = ChessboardSquare()

        switch square.type {
        case .goal:
            if self.mode == .placeKnight {
                let currentKnightPosition = self.currentKnightSquare.position

                let squareCurrentlyOnBoard = self.chessboard.board[currentKnightPosition.row][currentKnightPosition.column]
//                if squareCurrentlyOnBoard.type

            }
        case .knight:
            if self.mode == .placeGoal {

            }
        case .none:
            if self.mode == .placeKnight {

            } else {

            }
        default:
            break
        }

        self.delegate?.update(state: .newSquareState(newSquare: newSquare, oldSquare: oldSquare))
        
//        switch self.mode {
//        case .placeKnight:
//            let currentKnightPosition = self.currentKnightSquare.position
//
//            self.chessboard.board[currentKnightPosition.row][currentKnightPosition.column].type = .none
//
//            square.type = .knight
//
//            oldSquare = currentKnightSquare
//            self.currentKnightSquare = square
//
//        case .placeGoal:
//            let currentGoalPosition = self.currentGoalSquare.position
//            self.chessboard.board[currentGoalPosition.row][currentGoalPosition.column].type = .none
//
//            square.type = .goal
//
//            oldSquare = currentGoalSquare
//            self.currentGoalSquare = square
//
//        }
//
//        self.delegate?.update(state: .newSquareState(newSquare: newSquare, oldSquare: oldSquare))
    }
    
    func sliderDragged(to value: Float) {
        let roundedValue = lroundf(value)
        self.chessboard.size = roundedValue
        self.resetSpecialCurrentSquares()
        
        self.delegate?.update(state: .sliderValueChangedState(value: Float(roundedValue)))
        self.delegate?.update(state: .newChessboardState(chessboard: self.chessboard))
    }
    
    func switchToogled(to value: Bool) {
        self.mode = value ? .placeGoal : .placeKnight
    }
    
    func findPathButtonTapped() {
        guard let finalPointsAndMoves = self.chessboard.findThreeMovesPath(from: self.currentKnightSquare,
                                                                           to: self.currentGoalSquare) else {
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
