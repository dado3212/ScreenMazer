//
//  DefaultsManager.swift
//  ScreenMazer
//
//  Created by Alex Beals on 8/12/18.
//  Copyright © 2018 Beals, Alex. All rights reserved.
//

import ScreenSaver

class DefaultsManager {
    var defaults: ScreenSaverDefaults
    
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
    
    var solveColor: NSColor {
        set(newColor) {
            setAttribute(newColor, key: "solveColor")
        }
        get {
            return getSolveColor() ?? .white
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
    
    var solveDuration: Int {
        set(newDuration) {
            setAttribute(newDuration, key: "solveDuration")
        }
        get {
            return getSolveDuration() ?? 10
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
    
    var solve: Bool {
        set(newSolve) {
            setAttribute(newSolve, key: "solve")
        }
        get {
            return getSolve() ?? true
        }
    }
    
    //    func setAttribute(_ attribute: Any, key: String) {
    //        //defaults.set(NSKeyedArchiver.archivedData(withRootObject: attribute), forKey: key)
    //        defaults.set(NSKeyedArchiver.archivedData(withRootObject: attribute, requiringSecureCoding: false), forKey: key)
    //        defaults.synchronize()
    //    }
    func setAttribute(_ attribute: Any, key: String) {
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: attribute, requiringSecureCoding: false) {
            defaults.set(data, forKey: key)
            defaults.synchronize()
        }
    }
    
    func getColor() -> NSColor? {
        if let info = defaults.data(forKey: "color"),
           let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: info) {
            return color
        }
        return nil
    }
    
    func getSolveColor() -> NSColor? {
        if let info = defaults.data(forKey: "solveColor"),
           let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: info) {
            return color
        }
        return nil
    }
    
    func getDuration() -> Int? {
        if let info = defaults.data(forKey: "duration"),
           let duration = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: info) as? Int {
            return duration
        }
        return nil
    }
    
    func getSolveDuration() -> Int? {
        if let info = defaults.data(forKey: "solveDuration"),
           let duration = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: info) as? Int {
            return duration
        }
        return nil
    }
    
    func getMazeSize() -> Double? {
        if let info = defaults.data(forKey: "mazeSize"),
           let mazeSize = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: info) as? Double {
            return mazeSize
        }
        return nil
    }
    
    func getClockSize() -> Int? {
        if let info = defaults.data(forKey: "clockSize"),
           let clockSize = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: info) as? Int {
            return clockSize
        }
        return nil
    }
    
    func getHourClock() -> Bool? {
        if let info = defaults.data(forKey: "hourClock"),
           let hourClock = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: info) as? Bool {
            return hourClock
        }
        return nil
    }
    
    func getSolve() -> Bool? {
        if let info = defaults.data(forKey: "solve"),
           let solve = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: info) as? Bool {
            return solve
        }
        return nil
    }
}
