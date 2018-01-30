//
//  Card.swift
//  bajsMemory
//
//  Created by Fanny Högberg on 2018-01-07.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import Foundation
import UIKit

class Card {
    
    let id : String
    let image : UIImage
    let backImage = UIImage(named: "cardBack")
    var isFlipped : Bool = false
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
    
    func setIsFlipped(status: Bool){
        isFlipped = status
    }
    
    
    func setCoordinates(x: Int, y: Int){
    self.xCoordinate = x
    self.yCoordinate = y
}
    
}
