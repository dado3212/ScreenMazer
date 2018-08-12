//
//  MazeGenerator.swift
//  MySwiftScreenSaver
//
//  Created by Alex Beals on 8/12/18.
//  Copyright © 2018 Hill, Michael. All rights reserved.
//

import Foundation

struct Point {
    var r = 0
    var c = 0
}

extension String {
    func random() -> String {
        let rand = Int(arc4random_uniform(UInt32(self.count)))
        let start = self.index(self.startIndex, offsetBy: rand)
        let end = self.index(self.startIndex, offsetBy: rand+1)
        return String(self[start..<end])
    }
}

class MazeGenerator {
    let rows: Int, cols: Int
    var blocked: [[Bool]] = []
    var orderChanged: [Point] = []

    let UP = "↑";
    let DOWN = "↓";
    let LEFT = "←";
    let RIGHT = "→";

    init(_ rows: Int, _ cols: Int) {
        self.rows = rows
        self.cols = cols

        let startingR = 1
        let startingC = 0
        let endingR = rows - 2
        let endingC = cols - 1

        blocked = Array(repeating: Array(repeating: true, count: cols), count: rows)
        blocked[startingR][startingC] = false
        blocked[endingR][endingC] = false

        // Create the maze
        createMaze()
        orderChanged.append(Point(r: startingR, c: startingC))
        orderChanged.append(Point(r: endingR, c: endingC))
    }

    func createMaze() {
        var back: Int
        var possibleDirections: String
        var pos: Point = Point(r: 1, c: 1)

        var moves: [Int] = []
        moves.append(pos.r + pos.c * cols)

        while (moves.count > 0) {
            possibleDirections = ""

            if ((pos.r + 2 < rows ) && (blocked[pos.r + 2][pos.c]) && (pos.r + 2 != rows - 1)) {
                possibleDirections += DOWN
            }

            if ((pos.r - 2 >= 0 ) && (blocked[pos.r - 2][pos.c]) && (pos.r - 2 != 0) ) {
                possibleDirections += UP
            }

            if ((pos.c - 2 >= 0 ) && (blocked[pos.r][pos.c - 2]) && (pos.c - 2 != 0) ) {
                possibleDirections += LEFT
            }

            if ((pos.c + 2 < cols ) && (blocked[pos.r][pos.c + 2])  && (pos.c + 2 != cols - 1) ) {
                possibleDirections += RIGHT
            }

            // Check if found any possible movements
            if (possibleDirections.count > 0) {
                switch (possibleDirections.random()) {
                case UP: // North
                    blocked[pos.r - 1][pos.c] = false
                    blocked[pos.r - 2][pos.c] = false
                    orderChanged.append(Point(r: pos.r - 1, c: pos.c))
                    orderChanged.append(Point(r: pos.r - 2, c: pos.c))
                    pos.r -= 2;
                    break;

                case DOWN: // South
                    blocked[pos.r + 1][pos.c] = false
                    blocked[pos.r + 2][pos.c] = false
                    orderChanged.append(Point(r: pos.r + 1, c: pos.c))
                    orderChanged.append(Point(r: pos.r + 2, c: pos.c))
                    pos.r += 2
                    break;

                case LEFT: // West
                    blocked[pos.r][pos.c - 1] = false
                    blocked[pos.r][pos.c - 2] = false
                    orderChanged.append(Point(r: pos.r, c: pos.c - 1))
                    orderChanged.append(Point(r: pos.r, c: pos.c - 2))
                    pos.c -= 2
                    break;

                case RIGHT: // East
                    blocked[pos.r][pos.c + 1] = false
                    blocked[pos.r][pos.c + 2] = false
                    orderChanged.append(Point(r: pos.r, c: pos.c + 1))
                    orderChanged.append(Point(r: pos.r, c: pos.c + 2))
                    pos.c += 2
                    break;

                default:
                    break;
                }

                // Add a new possible movement
                moves.append(pos.r + (pos.c * cols))
            } else {
                // There are no more possible movements
                back = moves.removeLast()
                pos.r = back % cols
                pos.c = back / cols
            }
        }
    }

    func mazeString() -> String {
        return printMaze(self.blocked)
    }

    func printMaze(_ maze: [[Bool]]) -> String {
        var fullMaze: String = ""

        for i in 0...rows-1 {
            for j in 0...cols-1 {
                if (maze[i][j]) {
                    fullMaze += "◼"
                } else {
                    fullMaze += "◻"
                }
            }
            fullMaze += "\n"
        }

        return fullMaze
    }
}
