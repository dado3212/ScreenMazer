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
    override init?(frame: NSRect, isPreview: Bool) {
        
        super.init(frame: frame, isPreview: isPreview)
        
        //register fonts
        
        //force registering fonts using the other bundle
        Bundle.registerFonts()
        
        //probably not needed, but cant hurt to check in case we re-use this code later
        for subview in self.subviews {
            subview.removeFromSuperview()
        }

        //Create the SpriteKit View
        let view: SKView = SKView(frame: self.bounds)

        //Create the scene and add it to the view
        let scene: SKScene = MazeScene(size: self.bounds.size)
        scene.scaleMode = .aspectFill
        view.presentScene(scene)

        //add it in as a subview
        self.addSubview(view)
    }

    override func hasConfigureSheet() -> Bool {
        return true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
