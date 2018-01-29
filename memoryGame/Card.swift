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
    
    let id : String
    let image : UIImage
    let backImage = UIImage(named: "cardBack")
    var isFlipped : Bool = false
    var audioPlayer : AVAudioPlayer!
    let sound : URL
    var xCoordinate = 0
    var yCoordinate = 0
    var width = 0
    var height = 0
    
    
    init(cardId: String, imageName: String, soundName: String) {
        id = cardId
        image = UIImage(named: imageName)!
        sound = Bundle.main.url(forResource: soundName, withExtension: "mp3")!

    }
    
    
    
    func setSize(imagewidth: Int, imageHeight: Int){
        width = imagewidth
        height = imageHeight
    }
    
    
    func playSound(){
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: sound)
        }
        catch{
            print(error)
        }
        audioPlayer.play()
        
    }
    
    
    func flipToShowImage(cardButton: UIButton) {
        if isFlipped == false{
            cardButton.setImage(image, for: .normal)
            UIView.transition(with: cardButton, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            isFlipped = true
            
        }
        
        
    }
    

    
    func flipToHide(cardButton: UIButton) {
        
        if isFlipped == true {
            cardButton.setImage(backImage, for: .normal)
            UIView.transition(with: cardButton, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            
            self.isFlipped = false
            
            
        }
        
    }
    
    
    func setCoordinates(x: Int, y: Int){
    self.xCoordinate = x
    self.yCoordinate = y
}
    
}
