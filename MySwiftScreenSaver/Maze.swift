//
//  Maze.swift
//  MySwiftScreenSaver
//
//  Created by Alex Beals on 8/11/18.
//  Copyright © 2018 Hill, Michael. All rights reserved.
//

import Foundation

struct Point {
    var x = 0
    var y = 0
}

extension String {
    func random() -> String {
        let rand = Int(arc4random_uniform(UInt32(self.count)))
        let start = self.index(self.startIndex, offsetBy: rand)
        let end = self.index(self.startIndex, offsetBy: rand+1)
        return String(self[start..<end])
    }
}

// Adapted from https://github.com/lucas-tulio/maze-generation-algorithms/blob/master/simple-maze/src/maze/Maze.java
class Maze {
    let width: Int, height: Int
    var blocked: [[Bool]] = []

    let UP = "↑";
    let DOWN = "↓";
    let LEFT = "←";
    let RIGHT = "→";

    init(_ width: Int, _ height: Int) {
        self.width = width
        self.height = height

        let startingX = 1
        let startingY = 0
        let endingX = width - 3
        let endingY = height - 2

        blocked = Array(repeating: Array(repeating: true, count: height), count: width)
        blocked[startingX][startingY] = false
        blocked[endingX][endingY] = false

        // Create the maze
        createMaze()
    }

    func createMaze() {
        print(self.blocked)
        var back: Int
        var possibleDirections: String
        var pos: Point = Point(x: 1, y: 1)

        var moves: [Int] = []
        moves.append(pos.y + pos.x * width)

        while (moves.count > 0) {
            possibleDirections = ""

            if ((pos.y + 2 < height ) && (blocked[pos.x][pos.y + 2]) && (pos.y + 2 != height - 1)) {
                possibleDirections += DOWN
            }

            if ((pos.y - 2 >= 0 ) && (blocked[pos.x][pos.y - 2]) && (pos.y - 2 != height - 1) ) {
                possibleDirections += UP
            }

            if ((pos.x - 2 >= 0 ) && (blocked[pos.x - 2][pos.y]) && (pos.x - 2 != width - 1) ) {
                possibleDirections += LEFT
            }

            if ((pos.x + 2 < width ) && (blocked[pos.x + 2][pos.y])  && (pos.x + 2 != width - 1) ) {
                possibleDirections += RIGHT
            }

            // Check if found any possible movements
            if (possibleDirections.count > 0) {
                switch (possibleDirections.random()) {
                case UP: // North
                    blocked[pos.x][pos.y - 2] = false
                    blocked[pos.x][pos.y - 1] = false
                    pos.y -= 2;
                    break;

                case DOWN: // South
                    blocked[pos.x][pos.y + 2] = false
                    blocked[pos.x][pos.y + 1] = false
                    pos.y += 2
                    break;

                case LEFT: // West
                    blocked[pos.x - 2][pos.y] = false
                    blocked[pos.x - 1][pos.y] = false
                    pos.x -= 2
                    break;

                case RIGHT: // East
                    blocked[pos.x + 2][pos.y] = false
                    blocked[pos.x + 1][pos.y] = false
                    pos.x += 2
                    break;

                default:
                    break;
                }

                // Add a new possible movement
                moves.append(pos.y + (pos.x * width))

            } else {

                // There are no more possible movements
                back = moves.removeLast()
                pos.x = back / width
                pos.y = back % width
            }
        }
        print(self.blocked)
    }

    func mazeString() -> String {
        var fullMaze: String = ""

        for i in 0...width-1 {
            for j in 0...height-1 {
                if (self.blocked[i][j]) {
                    fullMaze += "*"
                } else {
                    fullMaze += " "
                }
            }
            fullMaze += "\n"
        }

        return fullMaze
    }
}
