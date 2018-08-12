//
//  MazeGenerator.swift
//  ScreenMazer
//
//  Created by Alex Beals on 8/12/18.
//  Copyright © 2018 Beals, Alex. All rights reserved.
//

import Foundation

var digits: [String: String] = [
    "0": "111101101101111",
    "1": "010010010010010",
    "2": "111001111100111",
    "3": "111001011001111",
    "4": "101101111001001",
    "5": "111100111001111",
    "6": "111100111101111",
    "7": "111001001001001",
    "8": "111101111101111",
    "9": "111101111001001",
    ":": "000010000010000",
]

func timeToArray() -> [[Int]] {
    let defaults = DefaultsManager()
    let clockSize = defaults.clockSize

    // Get the time in String format
    let dateFormatter : DateFormatter = DateFormatter()
    dateFormatter.dateFormat = defaults.hourClock ? "HH:mm" : "hh:mm"
    let date = Date()
    let dateString = dateFormatter.string(from: date)
    print(dateString)

    var output: [[Int]] = Array(repeating: [], count: 5 * clockSize)

    // For each time block
    for (i, elem) in dateString.indices.enumerated() {
        let boolPattern = digits[String(dateString[elem])]!
        for (index, element) in boolPattern.indices.enumerated() {
            for _ in 1...clockSize {
                for j in 0...clockSize-1 {
                    output[index/3 * clockSize + j].append(Int(String(boolPattern[element]))!)
                }
            }
            if ((index + 1) % (3) == 0 && i != dateString.count-1) {
                for _ in 1...clockSize {
                    for j in 0...clockSize-1 {
                        output[index/3 * clockSize + j].append(0)
                    }
                }
            }
        }
    }

    var leftPad: [Int] = []
    var rightPad: [Int] = []
    for _ in 1...clockSize {
        leftPad.append(1)
        rightPad.append(0)
    }
    for _ in 1...clockSize {
        leftPad.append(0)
        rightPad.append(1)
    }
    for i in 0...output.count-1 {
        output[i].insert(contentsOf: leftPad, at: 0)
        output[i].append(contentsOf: rightPad)
    }

    // Top lines
    var intermediary = Array(repeating: 0, count: output[0].count-2*2*clockSize)
    intermediary.insert(contentsOf: leftPad, at: 0)
    intermediary.append(contentsOf: rightPad)
    for _ in 1...clockSize {
        output.insert(intermediary, at: 0)
    }
    for _ in 1...clockSize {
        output.insert(Array(repeating: 1, count: output[0].count), at: 0)
    }

    // Bottom lines
    intermediary = Array(repeating: 0, count: output[0].count-2*2*clockSize)
    intermediary.insert(contentsOf: leftPad, at: 0)
    intermediary.append(contentsOf: rightPad)
    for _ in 1...clockSize {
        output.append(intermediary)
    }
    for _ in 1...clockSize {
        output.append(Array(repeating: 1, count: output[0].count))
    }

    return output
}

class MazeGenerator {
    let rows: Int, cols: Int
    var blocked: [[Int]] = [] // 1 = WALL, 0 = SPACE, 2 = NO GO
    var orderChanged: [Square] = []

    let UP = "↑";
    let DOWN = "↓";
    let LEFT = "←";
    let RIGHT = "→";

    var start: Square
    var end: Square

    init(_ rows: Int, _ cols: Int) {
        self.rows = rows
        self.cols = cols

        let startingR = 1
        let startingC = 0
        start = Square(startingR, startingC)

        let endingR = rows - (rows % 2 == 0 ? 3 : 2)
        let endingC = cols - (cols % 2 == 0 ? 2 : 1)
        end = Square(endingR, endingC)

        blocked = Array(repeating: Array(repeating: 1, count: cols), count: rows)
        blocked[startingR][startingC] = 0
        blocked[endingR][endingC] = 0

        // Create time block
        let timeBools = timeToArray()
        // Center it
        let topOffset = rows / 2 - timeBools.count / 2
        let leftOffset = cols / 2 - timeBools[0].count / 2
        if (topOffset >= 0 && leftOffset >= 0) {
            for r in 0...timeBools.count-1 {
                for c in 0...timeBools[0].count-1 {
                    // If it won't crash
                    if (rows - r - topOffset >= 0 && c + leftOffset < cols - 1) {
                        blocked[rows-r-topOffset][c+leftOffset] = 2
                        if (timeBools[r][c] == 1) {
                            orderChanged.append(Square(rows-r-topOffset, c+leftOffset))
                        }
                    }
                }
            }
        }

        // Create the maze
        createMaze()
        orderChanged.append(start)
        orderChanged.append(end)
    }

    func createMaze() {
        var possibleDirections: String
        var pos: Square = start

        var moves: [Square] = [pos]

        while (moves.count > 0) {
            possibleDirections = ""

            if ((pos.r + 2 < rows ) && (blocked[pos.r + 2][pos.c] == 1) && (pos.r + 2 != rows - 1)) {
                possibleDirections += DOWN
            }

            if ((pos.r - 2 >= 0 ) && (blocked[pos.r - 2][pos.c] == 1) && (pos.r - 2 != 0) ) {
                possibleDirections += UP
            }

            if ((pos.c - 2 >= 0 ) && (blocked[pos.r][pos.c - 2] == 1) && (pos.c - 2 != 0) ) {
                possibleDirections += LEFT
            }

            if ((pos.c + 2 < cols ) && (blocked[pos.r][pos.c + 2] == 1)  && (pos.c + 2 != cols - 1) ) {
                possibleDirections += RIGHT
            }

            // Check if found any possible movements
            if (possibleDirections.count > 0) {
                switch (possibleDirections.random()) {
                case UP: // North
                    blocked[pos.r - 1][pos.c] = 0
                    blocked[pos.r - 2][pos.c] = 0
                    let first = Square(pos.r - 1, pos.c)
                    pos.nextTo(first)
                    let second = Square(pos.r - 2, pos.c)
                    first.nextTo(second)
                    orderChanged.append(first)
                    orderChanged.append(second)
                    pos = second
                    break;

                case DOWN: // South
                    blocked[pos.r + 1][pos.c] = 0
                    blocked[pos.r + 2][pos.c] = 0
                    let first = Square(pos.r + 1, pos.c)
                    pos.nextTo(first)
                    let second = Square(pos.r + 2, pos.c)
                    first.nextTo(second)
                    orderChanged.append(first)
                    orderChanged.append(second)
                    pos = second
                    break;

                case LEFT: // West
                    blocked[pos.r][pos.c - 1] = 0
                    blocked[pos.r][pos.c - 2] = 0
                    let first = Square(pos.r, pos.c - 1)
                    pos.nextTo(first)
                    let second = Square(pos.r, pos.c - 2)
                    first.nextTo(second)
                    orderChanged.append(first)
                    orderChanged.append(second)
                    pos = second
                    break;

                case RIGHT: // East
                    blocked[pos.r][pos.c + 1] = 0
                    blocked[pos.r][pos.c + 2] = 0
                    let first = Square(pos.r, pos.c + 1)
                    pos.nextTo(first)
                    let second = Square(pos.r, pos.c + 2)
                    first.nextTo(second)
                    orderChanged.append(first)
                    orderChanged.append(second)
                    pos = second
                    break;

                default:
                    break;
                }

                // Add a new possible movement
                moves.append(pos)
            } else {
                // There are no more possible movements
                pos = moves.removeLast()
            }
        }
    }
}
