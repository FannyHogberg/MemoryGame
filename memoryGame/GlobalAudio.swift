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

private let musicSettingKey = "musicSetting"
private let soundEffectKey = "soundEffectKey"


func playCardSoundEffect(card: Card){
    
    if soundEffectIsOn {
        if let player = audioEffectPlayer{
            if player.isPlaying{
                player.stop()
            }
        }
        if let filePath = Bundle.main.url(forResource: card.soundFileName, withExtension: "aif") {
            do {
                audioEffectPlayer = try AVAudioPlayer(contentsOf: filePath)
                audioEffectPlayer?.volume = 1
                audioEffectPlayer?.prepareToPlay()
                audioEffectPlayer?.play()
            }
            catch {
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
                pipeSoundPlayer?.volume = 0.45
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
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: filePath)
                backgroundMusicPlayer?.numberOfLoops = -1
                backgroundMusicPlayer?.volume = 0.5
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


//MARK: - INIT AND SAVE SOUND EFFECTS SETTINGS

func initialSoundEffectIsOn() -> Bool{
    
    let savedSoundSettings = UserDefaults.standard.object(forKey: soundEffectKey) as? Bool
    if let setting = savedSoundSettings {
        return setting
    } else {
        return true
    }
}

func saveSettingsFor(SoundEffects: Bool) {
    let defaults = UserDefaults.standard
    defaults.set(SoundEffects, forKey: soundEffectKey)
    defaults.synchronize()
}




//MARK: - INIT AND SAVE MUSIC SETTINGS
func initialBackgroundMusicIsOn() -> Bool {
    let savedMusicSetting = UserDefaults.standard.object(forKey: musicSettingKey) as? Bool
    if let setting = savedMusicSetting {
        return setting
    } else {
        return true
    }
}


func saveSettingFor(music: Bool) {
    let defaults = UserDefaults.standard
    defaults.set(music, forKey: musicSettingKey)
    defaults.synchronize()
}
