//
//  ChessboardTests.swift
//  KnightMovesThriceTests
//
//  Created by  Dimitris Tasios Personal on 22/10/23.
//

import XCTest
@testable import KnightMovesThrice

final class ChessboardAdvancedTests: XCTestCase {
    var chessboard = Chessboard(size: 8)
    
    enum KnightNumberOfMoves: Int {
        case one = 1
        case two
        case three
    }
    
    private func placeKnightAndGoal(solvable: Bool,
                                    numberOfMoves: KnightNumberOfMoves) -> (knight: ChessboardSquare, goal: ChessboardSquare)? {
        if solvable {
            switch numberOfMoves {
            case .one:
                self.chessboard.board[2][2].type = .knight
                self.chessboard.board[4][3].type = .goal
            case .two:
                self.chessboard.board[2][2].type = .knight
                self.chessboard.board[2][4].type = .goal
            case .three:
                self.chessboard.board[2][2].type = .knight
                self.chessboard.board[4][5].type = .goal
            }
        } else {
            self.chessboard.board[1][1].type = .knight
            self.chessboard.board[6][6].type = .goal
        }
        
        guard let knight = self.chessboard.getKnightOnBoard(), let goal = self.chessboard.getGoalOnBoard() else {
            return nil
        }
        
        return (knight: knight, goal: goal)
    }
    
    override func setUpWithError() throws {
        self.chessboard.size = 8
    }
    
    // Test no solution
    func test_NoSolution() throws {
        let squares = try XCTUnwrap(self.placeKnightAndGoal(solvable: false, numberOfMoves: .one), "Squares should on the board")
        
        XCTAssertNil(self.chessboard.findThreeMovesPath(from: squares.knight, to: squares.goal), "No path should be found")
    }
    
    // Test a solution that requires a single move
    func test_OneMoveSolution() throws {
        let squares = try XCTUnwrap(self.placeKnightAndGoal(solvable: true, numberOfMoves: .one), "Squares should on the board")
        
        let solution = try XCTUnwrap(self.chessboard.findThreeMovesPath(from: squares.knight, to: squares.goal), "A path should be found")
        
        XCTAssertEqual(solution.finalPoints.count, 2, "There should be 2 points in a one-move solution")
        XCTAssertEqual(solution.moves.count, 1, "There should be 1 move in a one-move solution")
    }
    
    // Test a solution that requires two moves
    func test_TwoMovesSolution() throws {
        let squares = try XCTUnwrap(self.placeKnightAndGoal(solvable: true, numberOfMoves: .two), "Squares should on the board")
        
        let solution = try XCTUnwrap(self.chessboard.findThreeMovesPath(from: squares.knight, to: squares.goal), "A path should be found")
        
        XCTAssertEqual(solution.finalPoints.count, 3, "There should be 3 points in a two-move solution")
        XCTAssertEqual(solution.moves.count, 2, "There should be 2 moves should be a two-move solution")
    }
    
    // Test a solution that requires three moves
    func test_ThreeMovesSolution() throws {
        let squares = try XCTUnwrap(self.placeKnightAndGoal(solvable: true, numberOfMoves: .three), "Squares should on the board")
        
        let solution = try XCTUnwrap(self.chessboard.findThreeMovesPath(from: squares.knight, to: squares.goal), "A path should be found")
        
        XCTAssertEqual(solution.finalPoints.count, 4, "There should be 4 points in a three-move solution")
        XCTAssertEqual(solution.moves.count, 3, "There should be 3 moves in a three-move solution")
    }
    
    // Test the path between two points is marked correctly
    func test_GetAllSquaresBetweenPoints() throws {
        let squares = try XCTUnwrap(self.placeKnightAndGoal(solvable: true, numberOfMoves: .one), "Squares should on the board")
        
        let solution = try XCTUnwrap(self.chessboard.findThreeMovesPath(from: squares.knight, to: squares.goal), "A path should be found")

        self.chessboard.addIntermediatePointsToPath(with: solution.finalPoints, and: solution.moves)
        
        XCTAssertEqual(self.chessboard.board[3][2].type, .pathStep1, "Square should be part of the path of the solution")
        XCTAssertEqual(self.chessboard.board[4][2].type, .pathStep1, "Square should be part of the path of the solution")
    }
}
