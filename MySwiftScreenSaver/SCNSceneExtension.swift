//
//  SCNSceneExtension.swift
//  MySwiftScreenSaver
//
//  Created by Hill, Michael on 6/30/16.
//  Copyright © 2016 Hill, Michael. All rights reserved.
//

import Cocoa
import SceneKit

extension SCNScene {
    
    public convenience init?(pathAwareName name: String) {
        let bundle = Bundle.pathAwareBundle()
        if let sceneURL = bundle.url( forResource: name, withExtension: nil) {
            try! self.init(url: sceneURL, options: nil )
            
            //attempt to fix materials, needed if you have paths in your bundle
            //repointMaterialForChildNodes(self.rootNode)
            
        } else {
            self.init(named: name)
        }
    }
    
    func repointMaterialForChildNodes( _ node: SCNNode) {
        for childNode in (node.childNodes) {
            //repoint all materials
            if let geometry = childNode.geometry {
                for material in geometry.materials {
                    repointMaterial(material)
                }
            }
            for newNode in childNode.childNodes {
                repointMaterialForChildNodes(newNode)
            }
        }
        
    }
    
    func repointMaterial(_ material: SCNMaterial) {
        let properties = [ material.diffuse, material.normal, material.specular, material.reflective]
        for property in properties {
            repointContentInMaterialProperty(property)
        }
    }
    
    func repointContentInMaterialProperty( _ property: SCNMaterialProperty ) {
        if let contents = property.contents {
            if let filename = filenameInMaterialContentDescription( (contents as AnyObject).description ) {
                if let newImage = NSImage(pathAwareName: filename) {
                    property.contents = newImage
                }
            }
        }
    }
    
    func filenameInMaterialContentDescription(_ contentString: String ) -> String? {
        let l = contentString.components(separatedBy: " -- ")
        let filePath = l[0]
        if let url = URL.init(string: filePath) {
            let components = url.pathComponents
            if components.count > 1 {
                if let lastComp = components.last {
                    return lastComp
                }
            }
        }
        
        //else
        return nil
    }
}
