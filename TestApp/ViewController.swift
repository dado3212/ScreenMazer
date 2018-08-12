//
//  ViewController.swift
//  TestApp
//
//  Created by Alex Beals on 8/12/18.
//  Copyright © 2018 Beals, Alex. All rights reserved.
//

import Cocoa
import SpriteKit

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Create the SpriteKit View
        let view: SKView = SKView(frame: self.view.bounds)

        //Create the scene and add it to the view
        var mazeScene = MazeScene(size: self.view.bounds.size)
        mazeScene.scaleMode = .aspectFill
        mazeScene.isPreview = false
        view.presentScene(mazeScene)

        //add it in as a subview
        self.view.addSubview(view)

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

