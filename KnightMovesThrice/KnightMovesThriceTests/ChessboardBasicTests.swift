//
//  ChessboardTests.swift
//  KnightMovesThriceTests
//
//  Created by  Dimitris Tasios Personal on 22/10/23.
//

import XCTest
@testable import KnightMovesThrice

final class ChessboardBasicTests: XCTestCase {
    var chessboard = Chessboard(size: 8)
    
    override func setUpWithError() throws {
        self.chessboard.size = 8 // this will redraw/reset the board automatically
    }
    
    // Test default initializer
    func test_DefaultInitializer() {
        let emptyChessboard = Chessboard()
        
        XCTAssertEqual(emptyChessboard.size, 0, "Empty chessboard should have a size of 0")
        XCTAssertEqual(emptyChessboard.board, [], "Empty chessboard should have an empty array")
    }
    
    // Test custom initializer
    func test_CustomInitializer() {
        let chessboardRows = chessboard.board.count
        let chessboardSquaresPerRow = chessboard.board[0].count
        
        XCTAssertEqual(chessboard.size, 8, "Chessbooard of 8x8 should have a size of 8")
        XCTAssertEqual(chessboardRows, 8, "A 8x8 chessboard should have 8 rows")
        XCTAssertEqual(chessboardSquaresPerRow, 8, "A 8x8 chessboard should have 8 squares per row")
    }
    
    // Test changing the size of a chessboard
    func test_ChangeChessboardSize() {
        chessboard.size = 6
        
        let chessboardRows = chessboard.board.count
        let chessboardSquaresPerRow = chessboard.board[0].count
        
        XCTAssertEqual(chessboard.size, 6, "New chessbooard of 6x6 should now have a size of 6")
        XCTAssertEqual(chessboardRows, 6, "The 6x6 chessboard should have 6 rows")
        XCTAssertEqual(chessboardSquaresPerRow, 6, "The 6x6 chessboard should have 6 squares per row")
    }
    
    // Test pattern of chessboard
    func test_PatterOfChessboard() {
        let evenRowEvenColumnColor = ChessboardSquareColor.black
        let oddRowOddColumnColor = ChessboardSquareColor.black
        let evenRowOddColumnColor = ChessboardSquareColor.white
        let oddRowAndEvenColumnColor = ChessboardSquareColor.white

        let evenRowEvenColumnSquare = chessboard.board[2][2]
        let oddRowOddColumnSquare = chessboard.board[1][5]
        let evenRowOddColumnSquare = chessboard.board[0][3]
        let oddRowEvenColumnSquare = chessboard.board[7][6]

        XCTAssertEqual(evenRowEvenColumnSquare.color, evenRowEvenColumnColor, "Even row & even column squares are black")
        XCTAssertEqual(oddRowOddColumnSquare.color, oddRowOddColumnColor, "Odd row & odd column squares are black")
        XCTAssertEqual(evenRowOddColumnSquare.color, evenRowOddColumnColor, "Even row & odd column squares are white")
        XCTAssertEqual(oddRowEvenColumnSquare.color, oddRowAndEvenColumnColor, "Odd row & even column squares are white")
    }
    
    // Test clearing previous solution path of chessboard
    func test_ClearSolution() {
        XCTAssertTrue(chessboard.board[2][3].type == .none, "Default type is empty for square (3,4)")
        XCTAssertTrue(chessboard.board[2][4].type == .none, "Default type is empty for square (3,5)")
        XCTAssertTrue(chessboard.board[2][5].type == .none, "Default type is empty for square (3,6)")
        XCTAssertTrue(chessboard.board[2][6].type == .none, "Default type is empty for square (3,7)")

        chessboard.board[2][3].type = .pathStep1
        chessboard.board[2][4].type = .pathStep2
        chessboard.board[2][5].type = .pathStep3
        chessboard.board[2][6].type = .solutionStep(title: "solution step")

        XCTAssertTrue(chessboard.board[2][3].type == .pathStep1, "Type changed for square (3,4) should be pathStep1")
        XCTAssertTrue(chessboard.board[2][4].type == .pathStep2, "Type changed for square (3,5) should be pathStep2")
        XCTAssertTrue(chessboard.board[2][5].type == .pathStep3, "Type changed for square (3,6) should be pathStep3")
        XCTAssertTrue(chessboard.board[2][6].type == .solutionStep(title: "solution step"), "Type changed for square (3,7) should be solutionStep")

        chessboard.clearSolutionAndPath()
        
        XCTAssertTrue(chessboard.board[2][3].type == .none, "Type should be reverted back to none for square (3,4)")
        XCTAssertTrue(chessboard.board[2][4].type == .none, "Type should be reverted back to none for square (3,5)")
        XCTAssertTrue(chessboard.board[2][5].type == .none, "Type should be reverted back to none for square (3,6)")
        XCTAssertTrue(chessboard.board[2][6].type == .none, "Type should be reverted back to none for square (3,7)")
    }
    
    // Test whether a knight and/or goal exist on the chessboard
    func test_KnightOrGoalExistOnBoard() throws {
        XCTAssertNil(chessboard.getKnightOnBoard())
        XCTAssertNil(chessboard.getGoalOnBoard())
        
        chessboard.board[1][4].type = .knight
        chessboard.board[3][3].type = .goal
        
        let knightSquare = try XCTUnwrap(chessboard.getKnightOnBoard(), "Knight square should not be nil")
        let goalSquare = try XCTUnwrap(chessboard.getGoalOnBoard(), "Goal square should not be nil")
        
        XCTAssertTrue(knightSquare.type == .knight, "Knight should exist on chessboard")
        XCTAssertTrue(goalSquare.type == .goal, "Goal should exist on chessboard")
    }
    
    // Test equality of two chessboards
    func test_EqualChessboards() {
        let chessboard1 = Chessboard(size: 4)
        let chessboard2 = Chessboard(size: 4)
        let chessboard3 = Chessboard(size: 4)
        let chessboard4 = Chessboard(size: 3)
        
        XCTAssertNotEqual(chessboard1, chessboard4)
        
        chessboard3.board[2][2].type = .knight
        XCTAssertNotEqual(chessboard1, chessboard3)
        
        XCTAssertEqual(chessboard1, chessboard2)
    }
}
