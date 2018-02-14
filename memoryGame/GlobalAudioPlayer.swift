//
//  GlobalAudioPlayer.swift
//  memoryGame
//
//  Created by Fanny Högberg on 2018-02-06.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import Foundation
import AVFoundation

    var backgroundMusic = Bundle.main.url(forResource: "music", withExtension: "mp3")

    var backgroundMusicPlayer: AVAudioPlayer!

    var audioEffectPlayer : AVAudioPlayer!

    var soundEffectIsOn = true

    var backgroundMusicIsOn = true

    var firstTime = true




func playSoundEffect(list : [Card], index: Int){
    
    if soundEffectIsOn{
    
    do {
        audioEffectPlayer = try AVAudioPlayer(contentsOf: list[index].sound)
    }
    catch{
        print(error)
    }
    audioEffectPlayer.play()
    
    
    }
}








func playBackgroundMusic(){
    
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: backgroundMusic!)
            backgroundMusicPlayer.numberOfLoops = -1
        }
        catch{
            print(error)
        }
        backgroundMusicPlayer.play()
        firstTime = false
    
}

func stopBackgroundMusic(){
    if backgroundMusicIsOn{
        backgroundMusicPlayer.stop()

    }
}




