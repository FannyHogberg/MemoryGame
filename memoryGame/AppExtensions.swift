////
////  AppExtensions.swift
////  memoryGame
////
////  Created by Fanny Högberg on 2018-03-06.
////  Copyright © 2018 Fanny Högberg. All rights reserved.
////
//
//import Foundation
//import UIKit
//import SpriteKit
//import AVFoundation
//
////Audio
//var audioPlayer = AVAudioPlayer()
//
//enum audioName : String {
//    case flushToilet = "flushToilet"
//    case FlushToiletLong = "flushToiletLong"
//    case plop = "plop"
//    case jippie = "jippie"
//    case nextLevel = "nextLevel"
//    case fart = "fart3"
//}
//
//enum fileType : String {
//    case wav = "wav"
//    case mp3 = "mp3"
//}
//
//extension AVAudioPlayer {
//    
//    
////
////    func playAudioFromCard(audioFileName:String,audioFileType:fileType)
////    {
////        if soundEffectIsOn{
////
////            if audioPlayer.isPlaying{
////
////                audioPlayer.setVolume(0.0, fadeDuration: 0.02)
////
////
////            }
////
////            if let filePath = Bundle.main.url(forResource: audioFileName, withExtension: audioFileType.rawValue){
////
////                do {
////                    // Removed deprecated use of AVAudioSessionDelegate protocol
////                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
////                    try AVAudioSession.sharedInstance().setActive(true)
////                    try audioPlayer = AVAudioPlayer(contentsOf: filePath as URL)
////                    audioPlayer.volume = 1
////                    audioPlayer.prepareToPlay()
////                    audioPlayer.play()
////                }
////                catch {
////                    print(error)
////                }
////
////
////            }
////        }
////    }
//    
//    
//    
//    
//    func playAudioEffect(audioFile:audioName,audioFileType:fileType)
//    {
//        if soundEffectIsOn{
//            
//            
//            //            let alertSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: audioFile.rawValue, ofType: audioFileType.rawValue)!)
//            if let filePath = Bundle.main.url(forResource: audioFile.rawValue, withExtension: "wav")
//            {
//                do {
//                    // Removed deprecated use of AVAudioSessionDelegate protocol
//                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//                    try AVAudioSession.sharedInstance().setActive(true)
//                    try audioPlayer = AVAudioPlayer(contentsOf: filePath as URL)
//                    audioPlayer.prepareToPlay()
//                    audioPlayer.play()
//                }
//                catch {
//                    print(error)
//                    
//                }
//            }
//            
//        }
//    }
//    
//    
//    func playPipeAudio(){
//        
//        if soundEffectIsOn{
//            
//            
//            let fileNames = ["pipeSound1", "pipeSound2", "pipeSound3"]
//            let random = Int(arc4random_uniform(3))
//            
//            if let filePath = Bundle.main.url(forResource: fileNames[random], withExtension: "wav")
//            {
//                
//                do {
//                    // Removed deprecated use of AVAudioSessionDelegate protocol
//                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//                    try AVAudioSession.sharedInstance().setActive(true)
//                    try audioPlayer = AVAudioPlayer(contentsOf: filePath as URL)
//                    audioPlayer.volume = 0.5
//                    audioPlayer.prepareToPlay()
//                    audioPlayer.play()
//                    
//                }
//                catch {
//                    print(error)
//                }
//                
//            }
//        }
//    }
//    
//}
//
