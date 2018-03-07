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

var flushToiletPlayer : AVAudioPlayer?

var pipeSoundPlayer : AVAudioPlayer?

var plopInToiletPlayer : AVAudioPlayer?

var jippiePlayer : AVAudioPlayer?





func playCardSoundEffect(list : [Card], index: Int){
    
    if soundEffectIsOn{
        if let filePath = Bundle.main.url(forResource: list[index].soundFileName, withExtension: "wav")
        {
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




func playOneFart(){
    if soundEffectIsOn {
        if let filePath = Bundle.main.url(forResource: "fart3", withExtension: "wav")
        {
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
    




func playNextLevelAudio(){
    if soundEffectIsOn {
        if let filePath = Bundle.main.url(forResource: "nextLevel", withExtension: "wav")
        {
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


func playJippieAudio(){
    if soundEffectIsOn {
        if let filePath = Bundle.main.url(forResource: "jippie", withExtension: "wav")
        {
            do {
                jippiePlayer = try AVAudioPlayer(contentsOf: filePath)
                jippiePlayer?.play()
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
        if let filePath = Bundle.main.url(forResource: audioFileNames[randomNr], withExtension: "wav")
        {
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
        if let filePath = Bundle.main.url(forResource: "plop", withExtension: "wav")
        {
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
        if let filePath = Bundle.main.url(forResource: "flushToilet", withExtension: "wav")
        {
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




func playFlushToiletLongAudio(){
    
    if soundEffectIsOn {
        if let filePath = Bundle.main.url(forResource: "flushToilet", withExtension: "wav")
        {
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






func playBackgroundMusic(){
    
    if backgroundMusicIsOn{
        
        if let filePath = Bundle.main.url(forResource: "music", withExtension: "mp3")
        {
            
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
