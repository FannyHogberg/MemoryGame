//
//  GlobalAudioPlayer.swift
//  memoryGame
//
//  Created by Fanny Högberg on 2018-02-06.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import Foundation
import AVFoundation






var backgroundMusicPlayer: AVAudioPlayer?

var audioEffectPlayer : AVAudioPlayer?

var flushToiletPlayer : AVAudioPlayer?

var pipeSoundPlayer : AVAudioPlayer?

var plopInToiletPlayer : AVAudioPlayer?

var soundEffectIsOn = true

var backgroundMusicIsOn = true

var firstTime = true






func playSoundEffect(list : [Card], index: Int){
    
    if soundEffectIsOn{
        let filePath = Bundle.main.url(forResource: list[index].soundFileName, withExtension: "mp3")

        if let filePath = filePath{
            do {
                audioEffectPlayer = try AVAudioPlayer(contentsOf: filePath)
                audioEffectPlayer?.play()
            }
            catch{
                print(error)
            }
        }
    }
}




func playBackgroundMusic(){
    
    if backgroundMusicIsOn{
        
        let filePath = Bundle.main.url(forResource: "music", withExtension: "mp3")
        
        if let filePath = filePath{
            
            do{
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: filePath)
                backgroundMusicPlayer?.numberOfLoops = -1
                backgroundMusicPlayer?.volume = 0.1
                backgroundMusicPlayer?.play()
                firstTime = false
                
            }
            catch{
                print("file not found")
            }
            
        }
        
    }
}


func stopBackgroundMusic(){
    if backgroundMusicIsOn{
        
        backgroundMusicPlayer?.setVolume(0.0, fadeDuration: 2)
    }
}




func playNextLevelAudio(){
    if soundEffectIsOn {
        let filePath = Bundle.main.url(forResource: "nextLevel", withExtension: "mp3")
        
        if let filePath = filePath{
            do {
                audioEffectPlayer = try AVAudioPlayer(contentsOf: filePath)
                audioEffectPlayer?.play()
            }
            catch{
                print(error)
            }
        }
    }
}


func playPipeSound(){
    let audioFileNames = ["pipeSound1", "pipeSound2", "pipeSound3"]
    let randomNr = Int(arc4random_uniform(3))
    if soundEffectIsOn {
        let filePath = Bundle.main.url(forResource: audioFileNames[randomNr], withExtension: "mp3")
        
        if let filePath = filePath{
            do {
                pipeSoundPlayer = try AVAudioPlayer(contentsOf: filePath)
                pipeSoundPlayer?.volume = 0.1
                pipeSoundPlayer?.play()
            }
            catch{
                print(error)
            }
        }
    }
}




func playPlopInToilet(){
    if soundEffectIsOn {
        let filePath = Bundle.main.url(forResource: "plop", withExtension: "mp3")
        if let filePath = filePath{
            do {
                plopInToiletPlayer = try AVAudioPlayer(contentsOf: filePath)
                plopInToiletPlayer?.volume = 0.7
                plopInToiletPlayer?.play()
            }
            catch{
                print(error)
            }
        }
    }
}





func playFlushToiletAudio(){
    
    if soundEffectIsOn {
        let filePath = Bundle.main.url(forResource: "flushToilet", withExtension: "mp3")
        if let filePath = filePath{
            do {
                flushToiletPlayer = try AVAudioPlayer(contentsOf: filePath)
                flushToiletPlayer?.volume = 0.6
                flushToiletPlayer?.play()
                
            }
            catch{
                print(error)
            }
            
        }
    }
    
}





