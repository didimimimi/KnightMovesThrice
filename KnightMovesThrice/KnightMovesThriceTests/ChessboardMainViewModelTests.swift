//
//  ChessboardMainViewModelTests.swift
//  KnightMovesThriceTests
//
//  Created by  Dimitris Tasios Personal on 22/10/23.
//

import XCTest
@testable import KnightMovesThrice

final class ChessboardMainViewModelTests: XCTestCase {
    class MockScreen: ChessboardMainViewModelDelegate {
        var viewModel = ChessboardMainViewModel()
        var state = ChessboardMainStates.dummyState

        init() {
            self.viewModel = ChessboardMainViewModel(delegate: self)
        }
        
        func update(state: KnightMovesThrice.ChessboardMainStates) {
            self.state = state
        }
    }
    
    var mockScreen = MockScreen()
    
    override func setUpWithError() throws {
        mockScreen = MockScreen()
    }
    
    // Test initial state of view model
    func test_InitialState() {
        
        switch self.mockScreen.state {
        case .newChessboardState(let chessboard):
            XCTAssertEqual(chessboard.size, 8, "Initial board size should be 8")
        default:
            XCTFail("Incorrect state")
        }
    }
    
    // Test squared tapped intent and its connected state
    func test_SquareTapped() {
        var chessboard = Chessboard()
        
        switch self.mockScreen.state {
        case .newChessboardState(let stateChessboard):
            chessboard = stateChessboard
        default:
            XCTFail("Incorrect state")
        }
        
        self.mockScreen.viewModel.squareTapped(square: chessboard.board[4][4])
        
        switch self.mockScreen.state {
        case .newSquareState(let newSquare, _):
            XCTAssertEqual(newSquare, chessboard.board[4][4], "Incorrect square tapped")
        default:
            XCTFail("Incorrect state")
        }
    }
    
    // Test squared tapped and the knight has a new position while erasing the old one
    func test_SquareTappedAndKnightUpdatedItsPosition() throws {
        var chessboard = Chessboard()

        switch self.mockScreen.state {
        case .newChessboardState(let stateChessboard):
            chessboard = stateChessboard
        default:
            XCTFail("Incorrect state")
        }

        chessboard.board[3][3].type = .knight

        XCTAssertEqual(chessboard.board[3][3].type, .knight, "This square should be a knight")
        XCTAssertEqual(chessboard.board[4][4].type, .none, "This square should be empty")

        self.mockScreen.viewModel.squareTapped(square: chessboard.board[4][4])

        switch self.mockScreen.state {
        case .newSquareState(let newSquare, let theOldSquare):
            XCTAssertEqual(newSquare, chessboard.board[4][4], "New square should be the new knight square that was empty before")
            XCTAssertEqual(newSquare.type, .knight, "New square should be a knight")
            
            let oldSquare = try XCTUnwrap(theOldSquare)
            
            XCTAssertEqual(oldSquare, chessboard.board[3][3], "Old square should be the old knight")
            XCTAssertEqual(oldSquare.type, .none, "Old square is now empty")
        default:
            XCTFail("Incorrect state")
        }
    }
    
    // Test toogle to goal placement mode, tap a square and the goal has a new position while erasing the old one
    func test_SquareTappedAndGoalUpdatedItsPosition() throws {
        var chessboard = Chessboard()

        switch self.mockScreen.state {
        case .newChessboardState(let stateChessboard):
            chessboard = stateChessboard
        default:
            XCTFail("Incorrect state")
        }

        self.mockScreen.viewModel.switchToogled(to: true) // true means goal square should be placed on the board
        
        chessboard.board[3][3].type = .goal

        XCTAssertEqual(chessboard.board[3][3].type, .goal, "This square should be a goal")
        XCTAssertEqual(chessboard.board[4][4].type, .none, "This square should be empty")

        self.mockScreen.viewModel.squareTapped(square: chessboard.board[4][4])

        switch self.mockScreen.state {
        case .newSquareState(let newSquare, let theOldSquare):
            XCTAssertEqual(newSquare, chessboard.board[4][4], "New square should be the new goal square that was empty before")
            XCTAssertEqual(newSquare.type, .goal, "New square should be a goal")
            
            let oldSquare = try XCTUnwrap(theOldSquare)
            
            XCTAssertEqual(oldSquare, chessboard.board[3][3], "Old square should be the old goal")
            XCTAssertEqual(oldSquare.type, .none, "Old square is now empty")
        default:
            XCTFail("Incorrect state")
        }
    }
    
    // Test slider has changed chessboard size
    func test_SliderChangedChessboardSize() {
        self.mockScreen.viewModel.sliderDragged(to: 10)
        
        switch self.mockScreen.state {
        case .newChessboardState(let stateChessboard):
            XCTAssertEqual(stateChessboard.size, 10, "New chessboard size should be 10")
        default:
            XCTFail("Incorrect state")
        }
    }
    
    private func tapSquares(knightSquare: ChessboardSquare, goalSquare: ChessboardSquare) {
        knightSquare.type = .knight
        goalSquare.type = .goal
        
        self.mockScreen.viewModel.squareTapped(square: knightSquare)
        self.mockScreen.viewModel.switchToogled(to: true) // change to place goal
        self.mockScreen.viewModel.squareTapped(square: goalSquare)
    }
    
    // Test find path button tapped and a path is found
    func test_FindPathButtonTappedSuccessfulSolution() {
        var chessboard = Chessboard()

        switch self.mockScreen.state {
        case .newChessboardState(let stateChessboard):
            chessboard = stateChessboard
        default:
            XCTFail("Incorrect state")
        }

        self.tapSquares(knightSquare: chessboard.board[2][2], goalSquare: chessboard.board[4][3])
        
        self.mockScreen.viewModel.findPathButtonTapped()
        
        switch self.mockScreen.state {
        case .newChessboardState(let stateChessboard):
            XCTAssertEqual(stateChessboard.board[2][2].type, .knight, "Square should be a knight")
            XCTAssertEqual(stateChessboard.board[3][2].type, .pathStep1, "Square should be part of the path of the solution")
            XCTAssertEqual(stateChessboard.board[4][2].type, .pathStep1, "Square should be part of the path of the solution")
            XCTAssertEqual(stateChessboard.board[4][3].type, .goal, "Square should be a goal")
        default:
            XCTFail("Incorrect state")
        }
    }
    
    // Test no solution
    func test_NoPathBetweenPoints() {
        var chessboard = Chessboard()

        switch self.mockScreen.state {
        case .newChessboardState(let stateChessboard):
            chessboard = stateChessboard
        default:
            XCTFail("Incorrect state")
        }

        self.tapSquares(knightSquare: chessboard.board[2][2], goalSquare: chessboard.board[7][7])

        self.mockScreen.viewModel.findPathButtonTapped()
        
        switch self.mockScreen.state {
        case .noPathState:
            break // this means that we'll pass automatically, by not failing
        default:
            XCTFail("Incorrect state")
        }
    }
    
    // Test reset button tapped {
    func test_ResetButton() {
        var chessboard = Chessboard()

        switch self.mockScreen.state {
        case .newChessboardState(let stateChessboard):
            chessboard = stateChessboard
        default:
            XCTFail("Incorrect state")
        }

        self.tapSquares(knightSquare: chessboard.board[2][2], goalSquare: chessboard.board[4][3])

        self.mockScreen.viewModel.findPathButtonTapped()
        
        self.mockScreen.viewModel.resetButtonTapped()
        
        switch self.mockScreen.state {
        case .newChessboardState(let stateChessboard):
            XCTAssertEqual(chessboard, stateChessboard)
        default:
            XCTFail("Incorrect state")
        }
    }
}
