//
//  DefaultsManager.swift
//  ScreenMazer
//
//  Created by Alex Beals on 8/12/18.
//  Copyright © 2018 Beals, Alex. All rights reserved.
//

import ScreenSaver

class DefaultsManager {
    var defaults: UserDefaults

    init() {
        let identifier = Bundle(for: DefaultsManager.self).bundleIdentifier
        defaults = ScreenSaverDefaults.init(forModuleWithName: identifier!)!
    }

    var color: NSColor {
        set(newColor) {
            setAttribute(newColor, key: "color")
        }
        get {
            return getColor() ?? .gray
        }
    }

    var duration: Int {
        set(newDuration) {
            setAttribute(newDuration, key: "duration")
        }
        get {
            return getDuration() ?? 30
        }
    }

    var size: Int {
        set(newSize) {
            setAttribute(newSize, key: "size")
        }
        get {
            return getSize() ?? 10
        }
    }

    func setAttribute(_ attribute: Any, key: String) {
        defaults.set(NSKeyedArchiver.archivedData(withRootObject: attribute), forKey: key)
        defaults.synchronize()
    }

    func getColor() -> NSColor? {
        if let info = defaults.object(forKey: "color") as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: info) as? NSColor
        }
        return nil
    }

    func getDuration() -> Int? {
        if let info = defaults.object(forKey: "duration") as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: info) as? Int
        }
        return nil
    }

    func getSize() -> Int? {
        if let info = defaults.object(forKey: "size") as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: info) as? Int
        }
        return nil
    }


}
