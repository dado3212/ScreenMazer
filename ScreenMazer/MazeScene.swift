//
//  MazeScene.swift
//  ScreenMazer
//
//  Created by Alex Beals on 8/12/18.
//  Copyright © 2018 Beals, Alex. All rights reserved.
//

import Foundation
import SpriteKit

class MazeScene: SKScene {
    var maze: MazeGenerator?

    var rows: Int = 10
    var cols: Int = 10
    var squareSize: CGFloat = CGFloat(DefaultsManager().mazeSize)

    var squares: [[SKSpriteNode]] = []

    var duration: Int = DefaultsManager().duration
    var lastUpdateTime = 0.0
    var d = 0.0
    var solveSpeed: Int = 5
    var solve: Bool = true

    var delay: Double = 2.5
    var pause: Int = -1
    var index = 0

    var isPreview: Bool = false

    // MARK: -View Class Methods
    // Custom initializer method
    override init(size: CGSize) {
        super.init(size: size)
        // self.backgroundColor = .blue
    }

    // We have to add the code below to stop Xcode complaining
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        backgroundColor = .black
        generateMaze()
    }

    func generateMaze() {
        // Clear everything
        index = 0
        for s in squares {
            for square in s {
                square.removeFromParent()
            }
        }
        squares = []
        squareSize = CGFloat(DefaultsManager().mazeSize)
        if (isPreview) {
            squareSize = squareSize / 4
            if (squareSize < 1) {
                squareSize = 1
            }
        }
        duration = DefaultsManager().duration

        // Add a bunch of squares
        rows = Int(size.height / squareSize)
        cols = Int(size.width / squareSize)
        maze = MazeGenerator(rows, cols)

        let bottomOffset = (size.height - CGFloat(rows) * squareSize) / 2
        let leftOffset = (size.width - CGFloat(cols) * squareSize) / 2

        solve = DefaultsManager().solve
        d = Double(maze!.orderChanged.count) / Double(duration)

        for r in 0...rows-1 {
            squares.append([])
            for c in 0...cols-1 {
                let square = SKSpriteNode()
                square.color = .black
                square.size = CGSize(width: squareSize, height: squareSize)
                square.anchorPoint = CGPoint(x: 0, y: 1)

                square.position = CGPoint(x: CGFloat(c) * squareSize + leftOffset, y: CGFloat(r) * squareSize + squareSize + bottomOffset)

                squares[r].append(square)

                addChild(square)
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if (maze == nil) {
            return
        }

        if (index == maze!.orderChanged.count) {
            pause = 60
            index += 1
            return
        } else if (solve && index == maze!.orderChanged.count + maze!.solution.count) {
            pause = 120
            index += 1
            return
        }

        if (pause > 0) {
            pause -= 1
            return
        } else if (pause == 0) {
            pause = -1
            index -= 1
        }

        // Calculate step speed
        let timeSinceLastUpdate = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        var stepSpeed = Int(d * timeSinceLastUpdate)
        if (stepSpeed < 1) { stepSpeed = 1 }

        // Drawing the original maze and time
        if (index < maze!.orderChanged.count) {
            for i in 1...stepSpeed {
                if (index < maze!.orderChanged.count) {
                    let pos = maze!.orderChanged[index]

                    squares[pos.r][pos.c].removeAllActions()
                    squares[pos.r][pos.c].run(SKAction.colorize(with: DefaultsManager().color, colorBlendFactor: 1, duration: 0.5))

                    index += (i == stepSpeed ? 0 : 1)
                } else {
                    index -= 1
                }
            }
        // Drawing the solution
        } else if (solve && index < maze!.orderChanged.count + maze!.solution.count) {
            for i in 1...solveSpeed {
                if (index < maze!.orderChanged.count + maze!.solution.count) {
                    let pos = maze!.solution[index - maze!.orderChanged.count]

                    squares[pos.r][pos.c].removeAllActions()
                    squares[pos.r][pos.c].run(SKAction.colorize(with: DefaultsManager().solveColor, colorBlendFactor: 1, duration: 0.5))

                    index += (i == solveSpeed ? 0 : 1)
                } else {
                    index -= 1
                }
            }
        // Resetting to black
        } else {
            // Reset them to black
            for r in 0...rows-1 {
                for c in 0...cols-1 {
                    squares[r][c].removeAllActions()
                    squares[r][c].color = .black
                    // squares[r][c].run(SKAction.colorize(with: .black, colorBlendFactor: 1, duration: TimeInterval(delay - 0.75)))
                }
            }

            // Update the maze
            maze = MazeGenerator(rows, cols)
            index = -1
        }

        // Normal proceedings
        index += 1
    }
}
