//
//  Card.swift
//  bajsMemory
//
//  Created by Fanny Högberg on 2018-01-07.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Card {
    
    var audioPlayer : AVAudioPlayer?
    let id : Int
    let image : UIImage
    let backImage = UIImage(named: "cardBack1")
    let soundFileName : String
    var isFlipped : Bool = false
    var flippedCounter = 0
    
    
    init(cardId: Int, imageName: String, soundName: String) {
        id = cardId
        image = UIImage(named: imageName)!
        soundFileName = soundName
    }
        
        func playSound(){
            
            if soundEffectIsOn{
            audioPlayer?.play()
            }
        }
    
    
    func flipCard(){
        if isFlipped == true{
            isFlipped = false
        }
        else{
            isFlipped = true
            flippedCounter += 1
        }
    }
    
    func setIsFlippedToFalse(){
        isFlipped = false
    }
    
    
    func resetCard(){
        isFlipped = false
        flippedCounter = 0
    }
    
}
