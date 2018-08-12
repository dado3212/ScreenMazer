//
//  NSImageExtensions.swift
//  ScreenMazer
//
//  Created by Hill, Michael on 7/1/16.
//  Copyright © 2016 Hill, Michael. All rights reserved.
//

import Cocoa

extension NSImage {
    
    public convenience init?(pathAwareName name:String ) {
        if let imageURL = Bundle.pathAwareBundle().url(forResource: name, withExtension: nil) {
            self.init(contentsOf: imageURL)!
        } else {
            self.init(named: name)
        }
    }
}
