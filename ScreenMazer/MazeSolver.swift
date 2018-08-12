//
//  MazeSolver.swift
//  ScreenMazer
//
//  Created by Alex Beals on 8/12/18.
//  Copyright © 2018 Beals, Alex. All rights reserved.
//

import Foundation
import GameplayKit

class Path {
    public let cumulativeWeight: Int
    public let node: Square
    public let previousPath: Path?

    init(to node: Square, previousPath path: Path? = nil) {
        if
            let previousPath = path {
            self.cumulativeWeight = 1 + previousPath.cumulativeWeight
        } else {
            self.cumulativeWeight = 0
        }

        self.node = node
        self.previousPath = path
    }
}

class MazeSolver {

    var solution: [Square] = []

    init(_ maze: MazeGenerator) {
        var end = Square(maze.end.r, maze.end.c - 2)
        var p = shortestPath(source: maze.start, destination: end)
        while (p != nil) {
            solution.insert(p!.node, at: 0)
            p = p!.previousPath
        }
    }

    func shortestPath(source: Square, destination: Square) -> Path? {
        var frontier: [Path] = [] {
            didSet { frontier.sort { return $0.cumulativeWeight < $1.cumulativeWeight } } // the frontier has to be always ordered
        }

        frontier.append(Path(to: source)) // the frontier is made by a path that starts nowhere and ends in the source

        var visited: [Square] = []

        while !frontier.isEmpty {
            let cheapestPathInFrontier = frontier.removeFirst() // getting the cheapest path available
            guard !visited.contains(cheapestPathInFrontier.node) else { continue } // making sure we haven't visited the node already

            if cheapestPathInFrontier.node === destination {
                return cheapestPathInFrontier // found the cheapest path 😎
            }

            visited.append(cheapestPathInFrontier.node)

            for s in cheapestPathInFrontier.node.adjacent where !visited.contains(s) { // adding new paths to our frontier
                frontier.append(Path(to: s, previousPath: cheapestPathInFrontier))
            }
        } // end while
        return nil // we didn't find a path 😣
    }
}
