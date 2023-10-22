//
//  ChessboardSquarePositionTests.swift
//  KnightMovesThriceTests
//
//  Created by  Dimitris Tasios Personal on 22/10/23.
//

import XCTest
@testable import KnightMovesThrice

final class ChessboardSquareTests: XCTestCase {
    
    // Test case for position default initializer
    func test_PositionDefaultInitializer() {
        let position = ChessboardSquarePosition()
        XCTAssertEqual(position.row, 0, "Default row should be 0")
        XCTAssertEqual(position.column, 0, "Default column should be 0")
    }
    
    // Test case for position custom initializer
    func test_PositionCustomInitializer() {
        let position = ChessboardSquarePosition(row: 2, column: 3)
        XCTAssertEqual(position.row, 2, "Row should be 2")
        XCTAssertEqual(position.column, 3, "Column should be 3")
    }
    
    // Test case for position equality
    func test_PositionEquality() {
        let position1 = ChessboardSquarePosition(row: 2, column: 3)
        let position2 = ChessboardSquarePosition(row: 2, column: 3)
        let position3 = ChessboardSquarePosition(row: 4, column: 1)
        
        XCTAssertEqual(position1, position2, "Positions with the same row and column should be equal")
        XCTAssertNotEqual(position1, position3, "Positions with different row or column should not be equal")
    }
    
    // Test case for square default initializer
    func test_SquareDefaultInitializer() {
        let square = ChessboardSquare()
        
        XCTAssertEqual(square.position, ChessboardSquarePosition(), "Position should be (0, 0)")
        XCTAssertEqual(square.type, .none, "Type should be \"none\"")
        XCTAssertEqual(square.description, "Position: Row: 1, Column: 1, Type: none")
        XCTAssertEqual(square.color, .white, "Default color chosen randomly as white should be white")
    }
    
    // Test case for square custom initializer
    func test_SquareCustomInitializer() {
        let square = ChessboardSquare(position: ChessboardSquarePosition(row: 4, column: 5),
                                      color: .black,
                                      type: .knight)
        
        XCTAssertEqual(square.position, ChessboardSquarePosition(row: 4, column: 5), "Position should be (4, 5)")
        XCTAssertEqual(square.type, .knight, "Type should be \"knight\"")
        XCTAssertEqual(square.description, "Position: Row: 5, Column: 6, Type: knight")
        XCTAssertEqual(square.color, .black, "Color should be black")
    }
    
    // Test case for square equality
    func test_SquareEquality() {
        let square1 = ChessboardSquare(position: ChessboardSquarePosition(row: 4, column: 5),
                                       color: .black,
                                       type: .knight)
        let square2 = ChessboardSquare(position: ChessboardSquarePosition(row: 4, column: 5),
                                       color: .black,
                                       type: .knight)
        let square3 = ChessboardSquare(position: ChessboardSquarePosition(row: 2, column: 2),
                                       color: .black,
                                       type: .knight)
        let square4 = ChessboardSquare(position: ChessboardSquarePosition(row: 4, column: 5),
                                       color: .white,
                                       type: .knight)
        let square5 = ChessboardSquare(position: ChessboardSquarePosition(row: 4, column: 5),
                                       color: .black,
                                       type: .goal)
        
        XCTAssertEqual(square1, square2, "All attributes same")
        XCTAssertNotEqual(square1, square3, "Different positions")
        XCTAssertNotEqual(square1, square4, "Different colors")
        XCTAssertNotEqual(square1, square5, "Different types")

    }
}
