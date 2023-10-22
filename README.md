# KnightMovesThrice
A small project where a knight has to reach, from a starting point on a chessboard, the desired position in 3 moves or less

## Overview
Using a BFS algorithm, a knight on a chessboard tries to move around in a way that will allow it to reach the desired position using, at maximum, three moves.

The user selects two positions on the chessboards, one for the knight and one for its goal position. If a solution is possible, the path will be indicated on the board.

The main screen is built using the MVI architecture. The project includes Unit Tests.

## Main Screen
The main screen of the app is the following:

<img width="565" alt="Screenshot 2023-10-22 at 14 44 49" src="https://github.com/didimimimi/KnightMovesThrice/assets/44156940/7ff39818-3cb4-4e4a-a575-3256592d5e77">

The following elements are interactable:
- The board itself, where its square is tappable. Tapping a square will either place a knight or a goal marker on the specified square, depending on the selected mode (mentioned later below). Only one knight and one goal marker can exist at once. In other words, you can, of course, have 1 knight and 1 goal on the board but not 2+ knights or 2+ goals.
- The slider, which increases the size of the chessboard. The **size**  is defined as one dimension of the chessboard square, so a chessboard of size 8 is a 8x8 chessboard with 64 squares. The slider allows values from 6 to 16, both included. Sliding will cause the board to resize on the spot while still dragging. Any markers on the chessboard will be cleared while dragging.
- The mode switch, which decides whether tapping a square will place a knight or a goal marker.
- The "Find 3-Moves Path" button which will find, using BFS, a path between the knight and the goal markers. If none is found, an alert is shown informing the user. If a path is found, it's drawn on the board.
- The "Reset Board" button resets the board to its original state, by removing all markers from it. Additionally, the mode is reset back to placing a knight.

## Examples screens
In this section a few example screens will be shown.

### Solution with a 1-move path
<img width="565" alt="Screenshot 2023-10-22 at 15 21 24" src="https://github.com/didimimimi/KnightMovesThrice/assets/44156940/1bd870cf-f867-43ab-9c7b-c93b19ba469d">

In this case, a path is drawn between the two main markers, indicating which exact moves the BFS chose to find a solution. There are no intermediate points in this case.

### Solution with a 2-moves path
<img width="565" alt="Screenshot 2023-10-22 at 15 21 36" src="https://github.com/didimimimi/KnightMovesThrice/assets/44156940/a980cb70-66ad-4c94-a89a-a40041d53181">

In this case, a path is drawn between all markers. Since there was a need for a intermediate point (marked with a "1" in a blue square), the paths have a slightly different shade of gray in order to be easily discnernible if they happen to be next to each other.

### Solution with a 3-moves path
<img width="565" alt="Screenshot 2023-10-22 at 15 21 53" src="https://github.com/didimimimi/KnightMovesThrice/assets/44156940/047e5135-593d-4e2a-8c3c-96f9443524d4">

Same case as above but with 2 extra points or 3 moves in total. Again each path has a different shade of gray.

### No solution
<img width="565" alt="Screenshot 2023-10-22 at 15 22 06" src="https://github.com/didimimimi/KnightMovesThrice/assets/44156940/3e7d6933-3ef8-4391-a866-b22af0139c58">

In this case, there is no solution, so an alert is shown to the user.

## Explanation of models
In this section we'll briefly go over the main models and structure of the main screen.

### Models
The main model is the `Chessboard` class which represents a chessboard. It contains a size and an array of `ChessboardRow`.

```
class Chessboard: Equatable {
    
    var board = [ChessboardRow]()
    var size: Int {
        didSet {
            self.createChessboard()
        }
    }

    .......
}
 ```

The `ChessboardRow` is a typealias for an array of `ChessboardSquare`, while the latter represents a square on the chessboard and is defined as such:
```
class ChessboardSquare: Hashable {
    
    var position = ChessboardSquarePosition()
    var color = ChessboardSquareColor.white
    var type = ChessboardSquareType.none
    
    var description: String {
        return "Position: \(position.description), Type: \(type)"
    }
  .....
}
```

The `ChessboardSquarePosition` represents the x-y coordinates of a square.
```
class ChessboardSquarePosition: Hashable {
    let row: Int
    let column: Int
    
    var description: String {
        return "Row: \(row + 1), Column: \(column + 1)"
    }
  ....
}
```

The `color` and `type` are enums. The `color` is the original color of a square (black or white) and the type is the current type of the square. The current type of a square is, for example, a knight square, where the knight changes the current view of a square but its original underlying color is always the same. The `color` is used to reset the square back to normal when another square is tapped, since only the affected views are updated, for performance.
```
enum ChessboardSquareColor {
    case black
    case white
}

enum ChessboardSquareType: Equatable {
    case knight // knight sqare
    case goal // goal square
    case solutionStep(title: String) // blue intermediate point in solution
    case pathStep1 // first path with lighter shade of gray
    case pathStep2 // second path with a slightly darker shade of gray
    case pathStep3 // third path with a dark shade of gray
    case none // no marking
}

enum ChessboardMode { // changed by the toogle switch
    case placeKnight
    case placeGoal
}
```
The `Chessboard` class contains several other functionalities as well. They are split into multiple files, extending the original `Chessboard` class. This is done for improved clarity. Those functionalities are explained briefly below:

- func clearSolutionAndPath() : clears the board from the solutionStep and pathStepX markers. This is useful when, after finding a solution, we place either the knight or the goal to another square, without wanting to reset the board. Resetting the board would also remove the knight and goal markers.
- func getKnightOnBoard() -> ChessboardSquare? : Checks whether the chessboard contains a knight marker.
- func getGoalOnBoard() -> ChessboardSquare? : Checks whether the chessboard contains a goal marker.
- func createChessboard() : Creates a chessboard. This is done automatically when the `size` field of the `Chessboard` class is changed.
- func findThreeMovesPath(from knightSquare: ChessboardSquare,to goalSquare: ChessboardSquare) -> (finalPoints: [ChessboardSquare], moves: [KnightMove])? : Given the knight and goal markers, it returns all the points (knight, goal and intermediate points) as well as the moves done in order to reach to a solution.
- func addIntermediatePointsToPath(with finalPoints: [ChessboardSquare], and moves: [KnightMove]) : Uses the solution data in order to construct the entire path (the ones marked with shades of gray) and place it on the board as well.

## MVI
