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
        
        if let filePath = Bundle.main.url(forResource: soundName, withExtension: "aiff"){
            
            do {
                // Removed deprecated use of AVAudioSessionDelegate protocol
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                try audioPlayer = AVAudioPlayer(contentsOf: filePath as URL)
                audioPlayer?.prepareToPlay()
            }
            catch {
                print(error)
            }
            
            
        }
    }
    

        func playSound(){
            
            
            if soundEffectIsOn{
            
                if (audioPlayer?.isPlaying)! {
                audioPlayer?.stop()
            }
                
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
