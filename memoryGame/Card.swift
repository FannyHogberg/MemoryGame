//
//  Card.swift
//  bajsMemory
//
//  Created by Fanny Högberg on 2018-01-07.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import Foundation
import UIKit
class Card {
    
    let id : Int
    let image : UIImage
    let backImage = UIImage(named: "cardBack1") //remove
    let soundFileName : String
    var isFlipped : Bool = false {
        didSet {
            if isFlipped == true {
                flippedCounter += 1
            }
        }
    }
    var flippedCounter = 0
    
    init(cardId: Int, imageName: String, soundName: String) {
        id = cardId
        image = UIImage(named: imageName)!
        soundFileName = soundName
        
    }
    
    func flipCard() {
        isFlipped = !isFlipped
    }
    
    func setIsFlippedToFalse() {
        isFlipped = false
    }
    
    func resetCard(){
        isFlipped = false
        flippedCounter = 0
    }
}
