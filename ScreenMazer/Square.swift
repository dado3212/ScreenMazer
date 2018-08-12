//
//  Square.swift
//  ScreenMazer
//
//  Created by Alex Beals on 8/12/18.
//  Copyright © 2018 Beals, Alex. All rights reserved.
//

import Foundation

class Square {
    let r: Int
    let c: Int
    var adjacent: [Square] = []

    init(_ row: Int, _ col: Int) {
        self.r = row
        self.c = col
    }

    func nextTo(_ s: Square) {
        adjacent.append(s)
        s.adjacent.append(self)
    }
}

extension Square: Equatable {
    static func == (lhs: Square, rhs: Square) -> Bool {
        return
            lhs.r == rhs.r && lhs.c == rhs.c
    }
}
