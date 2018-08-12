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

    var mazeSize: Double {
        set(newSize) {
            setAttribute(newSize, key: "mazeSize")
        }
        get {
            return getMazeSize() ?? 7.0
        }
    }

    var clockSize: Int {
        set(newSize) {
            setAttribute(newSize, key: "clockSize")
        }
        get {
            return getClockSize() ?? 1
        }
    }

    var hourClock: Bool {
        set(newClock) {
            setAttribute(newClock, key: "hourClock")
        }
        get {
            return getHourClock() ?? false
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

    func getMazeSize() -> Double? {
        if let info = defaults.object(forKey: "mazeSize") as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: info) as? Double
        }
        return nil
    }

    func getClockSize() -> Int? {
        if let info = defaults.object(forKey: "clockSize") as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: info) as? Int
        }
        return nil
    }

    func getHourClock() -> Bool? {
        if let info = defaults.object(forKey: "hourClock") as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: info) as? Bool
        }
        return nil
    }


}
