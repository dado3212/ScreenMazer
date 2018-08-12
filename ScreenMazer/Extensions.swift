//
//  Extensions.swift
//  ScreenMazer
//
//  Created by Alex Beals on 8/12/18.
//  Copyright © 2018 Beals, Alex. All rights reserved.
//

import Foundation

extension String {
    func random() -> String {
        let rand = Int(arc4random_uniform(UInt32(self.count)))
        let start = self.index(self.startIndex, offsetBy: rand)
        let end = self.index(self.startIndex, offsetBy: rand+1)
        return String(self[start..<end])
    }
}
