//
//  CountUpTimer.swift
//  memoryGame
//
//  Created by Fanny Högberg on 2018-02-04.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import Foundation

class TimeTimer {
    
    var time = 0.0
    var timer: Timer?
    
    deinit {
        reset()
    }
    
    func start() {
        reset()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            self?.time += 0.1
        })
    }

    
    private func reset(){
        time = 0.0
        timer?.invalidate()
    }
}
