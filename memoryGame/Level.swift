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
    var pairOfCards = 2
    var pipeAnimationDuration = 0.8
    var pipeTimeInterval : Double = 1.0
    var pointsList = [Int]()
    
    
    func setNextLevel() {
        if levelNumber == 1{
            pairOfCards += 1
            pipeAnimationDuration = 0.6
            pipeTimeInterval = 0.8
            
        }
            
        else if levelNumber == 2{
            pairOfCards += 2
            pipeAnimationDuration = 0.5
            pipeTimeInterval = 0.7
        }
        
        levelNumber += 1
        
    }
    
    
    
    func resetLevel(){
        levelNumber = 1
        pairOfCards = 2
        pipeAnimationDuration = 0.8
        pipeTimeInterval = 1.0
        pointsList.removeAll()
    }
    
    
    func savePointsThisLevel(points : Int){
        pointsList.append(points)
    }
    
    
    
    //return -1 if no value is saved in pointsLevel
    func getPointThisLevel(levelNumber : Int) -> Int{
        
        if levelNumber >= 1 && levelNumber<=3 && pointsList.count == 3{
            
            return pointsList[levelNumber-1]
            
            
        }
        
        return -1
    }
    
    
    
    
    
    
    
}

