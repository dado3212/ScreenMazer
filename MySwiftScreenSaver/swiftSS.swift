//
//  swiftSS.swift
//  MySwiftScreenSaver
//
//  Created by Hill, Michael on 6/27/16.
//  Copyright © 2016 Hill, Michael. All rights reserved.
//

import ScreenSaver
import SceneKit

class swiftSS: ScreenSaverView {
    
    var scnView: SCNView!
    
    func prepareSceneKitView() {
        
        // create a new scene
        let scene = SCNScene(pathAwareName: "ship.scn")!

        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)

        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)

        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLight.LightType.omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)

        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = NSColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)

        // retrieve the ship node
        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!

        // animate the 3d object
        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))

        // retrieve the SCNView
        let scnView = self.scnView

        // set the scene to the view
        scnView?.scene = scene

        // allows the user to manipulate the camera ( not needed on saver )
        //scnView.allowsCameraControl = true

        // show statistics such as fps and timing information
        scnView?.showsStatistics = true
        
        //fixes low FPS if you need it
        //scnView.antialiasingMode = .None
    }
    
    override init?(frame: NSRect, isPreview: Bool) {
        
        super.init(frame: frame, isPreview: isPreview)
        
        //register fonts
        
        //force registering fonts using the other bundle
        Bundle.registerFonts()
        
        //probably not needed, but cant hurt to check in case we re-use this code later
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        //initialize the sceneKit view
        
        //openGL seems to perform much better on SS + SceneKit.  On multiple monitors this was causing fans to kick in using default ( Metal )
        let options = [SCNView.Option.preferredRenderingAPI: SCNRenderingAPI.openGLCore32.rawValue]
        self.scnView = SCNView.init(frame: self.bounds, options: nil )
    
        //prepare it with a scene
        prepareSceneKitView()
        
        //set scnView background color
        scnView.backgroundColor = NSColor.yellow
        
        //add it in as a subview
        self.addSubview(self.scnView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
