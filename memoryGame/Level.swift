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
    var nextLevelText = """
    Jippi!! Du klarade det!
    Nu kommer det mer bajs!
    """
    var pairOfCards = 2
    var noMoreLevel = false
    var cardWidth : Int
    var cardHeight : Int
    var viewHeight : Double
    var viewWidth : Double

 
    init(heightOfView: Double, widthOfView: Double ) {
        
        viewHeight = heightOfView
        viewWidth =  widthOfView
        
        cardWidth = Int(viewWidth * 0.2)
        cardHeight = Int(viewWidth * 0.2)
    }

    
    func setNextLevel() {
        if levelNumber == 1{
            
            nextLevelText = """
            Du är riktigt bra på det här!
            Nu blir det svårare
            """
            
            pairOfCards = 3
    
            cardWidth = Int(viewWidth * 0.25)
            cardHeight = Int(viewWidth * 0.25)
            
        }
        else if levelNumber == 2{
            
            nextLevelText = """
            Du klarade hela spelet!
            Vill du spela igen?
            """
            noMoreLevel = true
            pairOfCards = 5
            cardWidth = Int(viewWidth * 0.2)
            cardHeight = Int(viewWidth * 0.2)
            
        }
        levelNumber += 1
        
    }
    
    
    func resetLevel(){
        levelNumber = 1
        
        pairOfCards = 2
        
        noMoreLevel = false
        
    }
    
    

    
    
    
    
    
    
    
    
}

