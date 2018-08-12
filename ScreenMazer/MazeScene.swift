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
    var index = 0
    var squares: [[SKSpriteNode]] = []
    var squareSize: CGFloat = CGFloat(DefaultsManager().mazeSize)
    var duration: Int = DefaultsManager().duration
    var stepSpeed: Int = 10
    var delay: Double = 2.5
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

        stepSpeed = (rows * cols) / (duration * 40)
        if stepSpeed < 1 { stepSpeed = 1 }

        for r in 0...rows-1 {
            squares.append([])
            for c in 0...cols-1 {
                let square = SKSpriteNode()
                square.color = .black
                square.size = CGSize(width: squareSize, height: squareSize)
                square.anchorPoint = CGPoint(x: 0, y: 1)

                square.position = CGPoint(x: CGFloat(c) * squareSize, y: CGFloat(r) * squareSize + squareSize)

                squares[r].append(square)

                addChild(square)
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if (maze == nil) {
            return
        }

        if (index < maze!.orderChanged.count) {
            for i in 1...stepSpeed {
                if (index < maze!.orderChanged.count) {
                    let pos = maze!.orderChanged[index]

                    squares[pos.r][pos.c].removeAllActions()
                    squares[pos.r][pos.c].run(SKAction.colorize(with: DefaultsManager().color, colorBlendFactor: 1, duration: 0.5))

                    index += (i == stepSpeed ? 0 : 1)
                }
            }
        } else if (index == maze!.orderChanged.count + 30) {
            // Reset them to black
            for r in 0...rows-1 {
                for c in 0...cols-1 {
                    squares[r][c].removeAllActions()
                    squares[r][c].run(SKAction.colorize(with: .black, colorBlendFactor: 1, duration: TimeInterval(delay - 0.75)))
                }
            }

            // Update the maze
            maze = MazeGenerator(rows, cols)
        } else if (index == maze!.orderChanged.count + Int(delay * 60)) {
            index = -1
        }

        // Normal proceedings
        index += 1
    }
}
