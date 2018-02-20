//
//  Level.swift
//  memoryGame
//
//  Created by Fanny Högberg on 2018-01-25.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import Foundation

class Level{
    
    
    var levelNumber = 1
    var nextLevelText = "\(NSLocalizedString ("LEVEL", comment: "")) 2 👏🏽"
    var pairOfCards = 2
    var pipeAnimationDuration = 0.8
    var pipeTimeInterval : Double = 1.0
    
    
    
    func setNextLevel() {
        if levelNumber == 1{
            
            nextLevelText = "\(NSLocalizedString ("LEVEL", comment: "")) 3 👏🏽"
            pairOfCards = 3
            pipeAnimationDuration = 0.6
            pipeTimeInterval = 0.8
            
        }
            
        else if levelNumber == 2{
            
            nextLevelText = "\(NSLocalizedString ("END_OF_GAME_TEXT", comment: ""))"

            pairOfCards = 5
            pipeAnimationDuration = 0.5
            pipeTimeInterval = 0.7
        }
        
        levelNumber += 1
        
    }
    
    
    
    func resetLevel(){
        levelNumber = 1
        pairOfCards = 2
        nextLevelText = "\(NSLocalizedString ("LEVEL", comment: "")) 2 👏🏽"
        pipeAnimationDuration = 0.8
        pipeTimeInterval = 1.0
    }
    
    
    
    
    
    
    
    
    
    
    
}

