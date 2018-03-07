//
//  GlobalAudioPlayer.swift
//  memoryGame
//
//  Created by Fanny Högberg on 2018-02-06.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//


import Foundation
import UIKit
import AVFoundation


var soundEffectIsOn = true
var backgroundMusicIsOn = true
var firstTime = true

var backgroundMusicPlayer: AVAudioPlayer?
var audioEffectPlayer : AVAudioPlayer?
var pipeSoundPlayer : AVAudioPlayer?



func playCardSoundEffect(list : [Card], index: Int){
    
    if soundEffectIsOn{
        if let player = audioEffectPlayer{
            if player.isPlaying{
                player.stop()
            }
        }
        if let filePath = Bundle.main.url(forResource: list[index].soundFileName, withExtension: "aif"){
            do {
                audioEffectPlayer = try AVAudioPlayer(contentsOf: filePath)
                audioEffectPlayer?.volume = 0.9
                audioEffectPlayer?.prepareToPlay()
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

        if let player = pipeSoundPlayer{
            if player.isPlaying{
                player.stop()
            }
        }
        if let filePath = Bundle.main.url(forResource: audioFileNames[randomNr], withExtension: "aif")
        {
            do {
                pipeSoundPlayer = try AVAudioPlayer(contentsOf: filePath)
                pipeSoundPlayer?.volume = 0.25
                pipeSoundPlayer?.prepareToPlay()
                pipeSoundPlayer?.play()
            }
            catch{
                print(error)
            }
        }
    }
}




func playBackgroundMusic(){
    
    if backgroundMusicIsOn{
        
        if let filePath = Bundle.main.url(forResource: "music", withExtension: "mp3")
        {
            
            do{
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: filePath)
                backgroundMusicPlayer?.numberOfLoops = -1
                backgroundMusicPlayer?.volume = 0.3
                backgroundMusicPlayer?.prepareToPlay()
                backgroundMusicPlayer?.play()
                firstTime = false
                
            }
            catch{
                print("file not found")
            }
            
        }
        
    }
}



func fadeBackgroundMusic(seconds: Double){
    if backgroundMusicIsOn{
        backgroundMusicPlayer?.setVolume(0.0, fadeDuration: seconds)
    }
}






func stopBackgroundMusic(){
    if backgroundMusicIsOn{
        
        backgroundMusicPlayer?.stop()
    }
}
