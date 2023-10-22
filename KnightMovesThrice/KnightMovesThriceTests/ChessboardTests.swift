//
//  ChessboardTests.swift
//  KnightMovesThriceTests
//
//  Created by  Dimitris Tasios Personal on 22/10/23.
//

import XCTest
@testable import KnightMovesThrice

final class ChessboardTests: XCTestCase {
    var testChessboard: Chessboard?
    
    override func setUpWithError() throws {
        self.testChessboard = Chessboard(size: 8)
    }
    
    // Test default initializer
    func test_DefaultInitializer() {
        let emptyChessboard = Chessboard()
        
        XCTAssertEqual(emptyChessboard.size, 0, "Empty chessboard should have a size of 0")
        XCTAssertEqual(emptyChessboard.board, [], "Empty chessboard should have an empty array")
    }
    
    // Test custom initializer
    func test_CustomInitializer() throws {
        let chessboard = try XCTUnwrap(self.testChessboard, "Chessboard should not be nil")
        
        let chessboardRows = chessboard.board.count
        let chessboardSquaresPerRow = chessboard.board[0].count
        
        XCTAssertEqual(chessboard.size, 8, "Chessbooard of 8x8 should have a size of 8")
        XCTAssertEqual(chessboardRows, 8, "A 8x8 chessboard should have 8 rows")
        XCTAssertEqual(chessboardSquaresPerRow, 8, "A 8x8 chessboard should have 8 squares per row")
    }
    
    // Test changing the size of a chessboard
    func test_ChangeChessboardSize() throws {
        var chessboard = try XCTUnwrap(self.testChessboard, "Chessboard should not be nil")
        chessboard.size = 6
        
        let chessboardRows = chessboard.board.count
        let chessboardSquaresPerRow = chessboard.board[0].count
        
        XCTAssertEqual(chessboard.size, 6, "New chessbooard of 6x6 should now have a size of 6")
        XCTAssertEqual(chessboardRows, 6, "The 6x6 chessboard should have 6 rows")
        XCTAssertEqual(chessboardSquaresPerRow, 6, "The 6x6 chessboard should have 6 squares per row")
    }
    
    // Test pattern of chessboard
    func test_PatterOfChessboard() throws {
        var chessboard = try XCTUnwrap(self.testChessboard, "Chessboard should not be nil")

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
}
