//
//  GlobalAudioPlayer.swift
//  memoryGame
//
//  Created by Fanny Högberg on 2018-02-06.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import Foundation
import AVFoundation

    let backgroundMusic = Bundle.main.url(forResource: "music", withExtension: "mp3")
    let nextLevelAudio = Bundle.main.url(forResource: "nextLevel", withExtension: "mp3")!
    let flushToiletAudio = Bundle.main.url(forResource: "flushToilet", withExtension: "mp3")!
    let plopInToilet = Bundle.main.url(forResource: "plop", withExtension: "mp3")!

    let pipeSounds = [Bundle.main.url(forResource: "pipeSound1", withExtension: "mp3")!, Bundle.main.url(forResource: "pipeSound2", withExtension: "mp3")!, Bundle.main.url(forResource: "pipeSound3", withExtension: "mp3")!]


    var backgroundMusicPlayer: AVAudioPlayer!

    var audioEffectPlayer : AVAudioPlayer!

    var flushToiletPlayer : AVAudioPlayer!

    var pipeSoundPlayer : AVAudioPlayer!

    var plopInToiletPlayer : AVAudioPlayer!

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
    
    if backgroundMusicIsOn{

        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: backgroundMusic!)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.volume = 0.1
        }
        catch{
            print(error)
        }
        backgroundMusicPlayer.play()
        firstTime = false
}
}


func stopBackgroundMusic(){
    if backgroundMusicIsOn{
        
        backgroundMusicPlayer.setVolume(0.0, fadeDuration: 2)
    }
}




func playNextLevelAudio(){
    if soundEffectIsOn {

        do {
            audioEffectPlayer = try AVAudioPlayer(contentsOf: nextLevelAudio)
        }
        catch{
            print(error)
        }
        audioEffectPlayer.play()
    }
}


func playPipeSound(){
    
    let randomNr = Int(arc4random_uniform(3))
    if soundEffectIsOn {
        
        
        do {
            
            pipeSoundPlayer = try AVAudioPlayer(contentsOf: pipeSounds[randomNr])
            pipeSoundPlayer.volume = 0.1
            pipeSoundPlayer.play()
            
        }
        catch{
            print(error)
        }
        
    }
    
}


func playPlopInToilet(){
    if soundEffectIsOn {
        
        
        do {
            plopInToiletPlayer = try AVAudioPlayer(contentsOf: plopInToilet)
            plopInToiletPlayer.volume = 0.7
            
        }
        catch{
            print(error)
        }
        
        plopInToiletPlayer.play()
        
    }
    
}




    
    func playFlushToiletAudio(){

        if soundEffectIsOn {


            do {
                flushToiletPlayer = try AVAudioPlayer(contentsOf: flushToiletAudio)
                flushToiletPlayer.volume = 0.6
                
            }
            catch{
                print(error)
            }

            flushToiletPlayer.play()

          }

}

    



