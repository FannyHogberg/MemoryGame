//
//  CountUpTimer.swift
//  memoryGame
//
//  Created by Fanny Högberg on 2018-02-04.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import Foundation

class CountUpTimer{
    
    var time = 0.0
    var timer = Timer()
    
    func start(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(saveData), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func saveData(){
        time += 0.1
        print(time)
    }
    
    func reset(){
        time = 0.0
        timer.invalidate()
        
        
    }
    
    func paus () {
        
        timer.invalidate()
        
    }

    
    
    
    
}
