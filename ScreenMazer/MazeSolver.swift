//
//  MazeSolver.swift
//  ScreenMazer
//
//  Created by Alex Beals on 8/12/18.
//  Copyright © 2018 Beals, Alex. All rights reserved.
//

import Foundation

class MazeSolver {
    var solution: [Square] = []

    init(_ maze: MazeGenerator) {
        var curr: Square? = maze.end
        while (curr != nil) {
            solution.insert(curr!, at: 0)
            curr = curr!.prev
        }
    }
}
