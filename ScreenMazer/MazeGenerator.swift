//
//  MazeGenerator.swift
//  ScreenMazer
//
//  Created by Alex Beals on 8/12/18.
//  Copyright © 2018 Beals, Alex. All rights reserved.
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
    var blocked: [[Int]] = [] // 1 = true, 0 = false, 2 = NO
    var orderChanged: [Point] = []

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
        // Get the time in String format
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = DefaultsManager().hourClock ? "HH:mm" : "hh:mm"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        print(dateString)

        var output: [[Int]] = Array(repeating: [], count: 5)

        // For each time block
        for (i, elem) in dateString.indices.enumerated() {
            let boolPattern = digits[String(dateString[elem])]!
            for (index, element) in boolPattern.indices.enumerated() {
                output[index/3].append(Int(String(boolPattern[element]))!)
                if (index % 3 == 2 && i != dateString.count-1) {
                    output[index/3].append(0)
                }
            }
        }

        for i in 0...output.count-1 {
            output[i].insert(contentsOf: [1, 0], at: 0)
            output[i].append(contentsOf: [0, 1])
        }

        // Top two lines
        output.insert(Array(repeating: 0, count: output[0].count-2), at: 0)
        output[0].insert(1, at: 0)
        output[0].append(1)
        output.insert(Array(repeating: 1, count: output[0].count), at: 0)

        // Bottom two lines
        output.append(Array(repeating: 0, count: output[0].count-2))
        output[output.count-1].insert(1, at: 0)
        output[output.count-1].append(1)
        output.append(Array(repeating: 1, count: output[0].count))

        return output
    }

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

        blocked = Array(repeating: Array(repeating: 1, count: cols), count: rows)
        blocked[startingR][startingC] = 0
        blocked[endingR][endingC] = 0

        // Create time block
        let timeBools = timeToArray()
        // Center it
        let topOffset = rows / 2 - timeBools.count / 2
        let leftOffset = cols / 2 - timeBools[0].count / 2
        for r in 0...timeBools.count-1 {
            for c in 0...timeBools[0].count-1 {
                blocked[rows-r-topOffset][c+leftOffset] = 2
                if (timeBools[r][c] == 1) {
                    orderChanged.append(Point(r: rows-r-topOffset, c: c+leftOffset))
                }
            }
        }

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
                    orderChanged.append(Point(r: pos.r - 1, c: pos.c))
                    orderChanged.append(Point(r: pos.r - 2, c: pos.c))
                    pos.r -= 2;
                    break;

                case DOWN: // South
                    blocked[pos.r + 1][pos.c] = 0
                    blocked[pos.r + 2][pos.c] = 0
                    orderChanged.append(Point(r: pos.r + 1, c: pos.c))
                    orderChanged.append(Point(r: pos.r + 2, c: pos.c))
                    pos.r += 2
                    break;

                case LEFT: // West
                    blocked[pos.r][pos.c - 1] = 0
                    blocked[pos.r][pos.c - 2] = 0
                    orderChanged.append(Point(r: pos.r, c: pos.c - 1))
                    orderChanged.append(Point(r: pos.r, c: pos.c - 2))
                    pos.c -= 2
                    break;

                case RIGHT: // East
                    blocked[pos.r][pos.c + 1] = 0
                    blocked[pos.r][pos.c + 2] = 0
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
}
