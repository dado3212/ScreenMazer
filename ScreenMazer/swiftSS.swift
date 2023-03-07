//
//  swiftSS.swift
//  ScreenMazer
//
//  Created by Alex Beals on 8/12/18.
//  Copyright © 2018 Beals, Alex. All rights reserved.
//

import ScreenSaver
import SpriteKit

class swiftSS: ScreenSaverView {
    var defaultsManager: DefaultsManager = DefaultsManager()
    lazy var sheetController: ConfigureSheetController = ConfigureSheetController()

    var mazeScene: MazeScene?

    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        
        //probably not needed, but cant hurt to check in case we re-use this code later
        for subview in self.subviews {
            subview.removeFromSuperview()
        }

        //Create the SpriteKit View
        let view: SKView = SKView(frame: self.bounds)

        //Create the scene and add it to the view
        mazeScene = MazeScene(size: self.bounds.size)
        mazeScene!.scaleMode = .aspectFill
        mazeScene!.isPreview = isPreview
        view.presentScene(mazeScene)

        //add it in as a subview
        self.addSubview(view)
    }
    
    override var hasConfigureSheet: Bool {
        return true
    }

    override var configureSheet: NSWindow? {
        
        sheetController.callback = {
            if ((self.mazeScene) != nil) {
                // Re-trigger the setup for the maze
                self.mazeScene?.generateMaze()
            }
        }
        return sheetController.window
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
