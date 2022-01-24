//
//  Level.swift
//  memoryGame
//
//  Created by Fanny Högberg on 2018-01-25.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import Foundation

struct Level {
    var didFlipPairCount: Int = 0
    let displayName: String
    let levelNumber: Int
    let pairOfCardsCount: Int
    
    var score: Int {
        if didFlipPairCount == 0 { return 3 }
        if didFlipPairCount <= pairOfCardsCount * 2 { return 2 }
        return 1
    }
}

extension Level {
    static let level1 = Level(displayName: "Level 1", levelNumber: 0, pairOfCardsCount: 2)
    static let level2 = Level(displayName: "Level 2", levelNumber: 1, pairOfCardsCount: 3)
    static let level3 = Level(displayName: "Level 3", levelNumber: 2, pairOfCardsCount: 5)
}
