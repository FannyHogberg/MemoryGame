//
//  AudioEffectPlayer.swift
//  memoryGame
//
//  Created by Fanny Högberg on 2018-03-07.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import Foundation
import AVFoundation


enum audioName : String {
    case flushToilet = "flush"
    case FlushToiletLong = "flushLong"
    case plop = "plop"
    case jippie = "jippie"
    case nextLevel = "nextLevel"
    case fart = "fart3"

}

    class AudioEffectPlayer {
    

        
    var audioPlayer : AVAudioPlayer?
    
        init(soundName: audioName, volume: Float){
        
        if let filePath = Bundle.main.url(forResource: soundName.rawValue, withExtension: "aif"){
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: filePath as URL)
                if volume <= 1 && volume > 0{
                    audioPlayer?.volume = volume
                }
                else{
                    audioPlayer?.volume = 1
                }
                audioPlayer?.prepareToPlay()
            }
            catch {
                print(error)
            }
            
            
        }
        
        }
        
        
        
        
        func playSound(){
            
            if soundEffectIsOn{
                if let player = audioPlayer{
                    if player.isPlaying{
                        player.currentTime = 0
                        player.play()
                    }
                    else{
                        player.play()
                        
                    }
                }
            }
            
        }
        
        
    }
    
    
    
 
