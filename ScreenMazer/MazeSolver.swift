//
//  MazeSolver.swift
//  ScreenMazer
//
//  Created by Alex Beals on 8/12/18.
//  Copyright © 2018 Beals, Alex. All rights reserved.
//

import Foundation
import GameplayKit

class MazeSolver {

    var solution: [[Int]]

    init(_ maze: MazeGenerator) {
        // Build the GKGraph from the finished maze
        var mazeGraph = GKGridGraph(fromGridStartingAt: int2(0,0), width: Int32(maze.cols), height: Int32(maze.rows), diagonalsAllowed: false)

        // Remove anything that's not on the valid path
        for row in 0...maze.blocked.count-1 {
            for col in 0...maze.blocked[0].count-1 {
                if maze.blocked[row][col] != 0 {
                    let toRemove = mazeGraph.node(atGridPosition: int2(Int32(col),Int32(row)))
                    mazeGraph.remove([toRemove!])
                }
            }
        }

        // Get the shortest path
        let shortestPath = mazeGraph.findPath(from: mazeGraph.node(atGridPosition: maze.start)!, to: mazeGraph.node(atGridPosition: maze.end)!)

        solution = maze.blocked

        // Build it into the solution (4 is correct)
        for node in shortestPath {
            let pt = (node as! GKGridGraphNode).gridPosition
            solution[Int(pt.y)][Int(pt.x)] = 4
        }

    }
}
