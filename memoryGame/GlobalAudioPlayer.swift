//
//  GlobalAudioPlayer.swift
//  memoryGame
//
//  Created by Fanny Högberg on 2018-02-06.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox



var listOfUrlsForCard = [URL?]()

var backgroundMusicPlayer: AVAudioPlayer?

var audioEffectPlayer1 : AVAudioPlayer?

var audioEffectPlayer2 : AVAudioPlayer?

var audioEffectPlayer3 : AVAudioPlayer?

var audioEffectPlayer4 : AVAudioPlayer?

var soundEffectIsOn = true

var backgroundMusicIsOn = true

var firstTime = true

var soundURL: NSURL?
var soundID: SystemSoundID = 0






enum thisAudio : String {
    case flushToilet = "flushToilet"
    case FlushToiletLong = "flushToiletLong"
    case plop = "plop"
    case jippie = "jippie"
    case nextLevel = "nextLevel"
    case fart = "fart3"
}


func playThisSound(named : thisAudio){
    
    if soundEffectIsOn{
        
        if let filePath = Bundle.main.path(forResource: named.rawValue, ofType: "wav"){
            soundURL = NSURL(fileURLWithPath: filePath)
        }
        if let url = soundURL {
            AudioServicesCreateSystemSoundID(url, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
    }
}



func playSoundEffect(list : [Card], index: Int){

    if soundEffectIsOn{
        
        if let filePath = Bundle.main.path(forResource: list[index].soundFileName, ofType: "wav"){
            soundURL = NSURL(fileURLWithPath: filePath)
        }
        if let url = soundURL {
            AudioServicesCreateSystemSoundID(url, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
    }
}






func playPipeSound(){
    let audioFileNames = ["pipeSound1", "pipeSound2", "pipeSound3"]
    let randomNr = Int(arc4random_uniform(3))
    
    if soundEffectIsOn {
        
        if soundEffectIsOn{
            
            if let filePath = Bundle.main.path(forResource: audioFileNames[randomNr], ofType: "wav"){
                soundURL = NSURL(fileURLWithPath: filePath)
            }
            if let url = soundURL {
                AudioServicesCreateSystemSoundID(url, &soundID)
                AudioServicesPlaySystemSound(soundID)
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








