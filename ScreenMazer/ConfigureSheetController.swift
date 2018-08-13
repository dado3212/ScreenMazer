//
//  ConfigureSheetController.swift
//  ScreenMazer
//
//  Created by Alex Beals on 8/12/18.
//  Copyright © 2018 Beals, Alex. All rights reserved.
//

import Cocoa

class ConfigureSheetController : NSObject {
    var defaultsManager = DefaultsManager()
    var callback: (() -> Void)?

    @IBOutlet var window: NSWindow?
    @IBOutlet var canvasColorWell: NSColorWell?
    @IBOutlet var solveColorWell: NSColorWell!
    @IBOutlet var duration: NSTextField!
    @IBOutlet var mazeSize: NSSlider!
    @IBOutlet var solveDuration: NSTextField!
    @IBOutlet var clockSize: NSSlider!
    @IBOutlet var hourClock: NSButton!
    @IBOutlet var solveCheck: NSButton!

    override init() {
        super.init()
        let myBundle = Bundle(for: ConfigureSheetController.self)
        myBundle.loadNibNamed("ConfigureSheet", owner: self, topLevelObjects: nil)
        canvasColorWell!.color = defaultsManager.color
        solveColorWell.color = defaultsManager.solveColor
        duration.stringValue = String(defaultsManager.duration)
        solveDuration.stringValue = String(defaultsManager.solveDuration)
        mazeSize.doubleValue = Double(defaultsManager.mazeSize)
        clockSize.doubleValue = Double(defaultsManager.clockSize)
        hourClock.state = defaultsManager.hourClock ? NSControlStateValueOn : NSControlStateValueOff
        solveCheck.state = defaultsManager.solve ? NSControlStateValueOn : NSControlStateValueOff
    }

    @IBAction func colorFinished(_ sender: Any) {
        defaultsManager.color = canvasColorWell!.color
        callback?()
    }

    @IBAction func solveColorFinished(_ sender: Any) {
        defaultsManager.solveColor = solveColorWell.color
        callback?()
    }

    @IBAction func durationFinished(_ sender: Any) {
        defaultsManager.duration = Int(duration.stringValue)!
        callback?()
    }

    @IBAction func solveDurationFinished(_ sender: Any) {
        defaultsManager.solveDuration = Int(solveDuration.stringValue)!
        callback?()
    }


    @IBAction func mazeSizeFinished(_ sender: Any) {
        defaultsManager.mazeSize = mazeSize.doubleValue
        callback?()
    }

    @IBAction func clockSizeFinished(_ sender: Any) {
        defaultsManager.clockSize = Int(clockSize.doubleValue)
        callback?()
    }

    @IBAction func clockFinished(_ sender: Any) {
        defaultsManager.hourClock = (hourClock.state == NSControlStateValueOn)
        callback?()
    }

    @IBAction func solveFinished(_ sender: Any) {
        defaultsManager.solve = (solveCheck.state == NSControlStateValueOn)
        callback?()
    }

    @IBAction func closeConfigureSheet(_ sender: AnyObject) {        
        NSColorPanel.shared().close()
        window?.sheetParent!.endSheet(window!, returnCode: (sender.tag == 1) ? NSModalResponseOK : NSModalResponseCancel)
    }
}

