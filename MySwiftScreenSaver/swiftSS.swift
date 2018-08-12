//
//  swiftSS.swift
//  MySwiftScreenSaver
//
//  Created by Hill, Michael on 6/27/16.
//  Copyright © 2016 Hill, Michael. All rights reserved.
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

        //Add something to it!
        
//
//        let redBox: SKSpriteNode = SKSpriteNode(color: .red, size:CGSize(width: 300, height: 300))
//        redBox.position = CGPoint(x: 512, y: 384)
//        redBox.run(SKAction.repeatForever(SKAction.rotate(byAngle: 6, duration: 2)))
//        scene.addChild(redBox)

        //add it in as a subview
        self.addSubview(view)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}