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
    let sound : URL
    var isFlipped : Bool = false
    
    
    init(cardId: String, imageName: String, soundName: String) {
        id = cardId
        image = UIImage(named: imageName)!
        sound = Bundle.main.url(forResource: soundName, withExtension: "mp3")!

    }

    
    func setIsFlipped(status: Bool){
        isFlipped = status
    }
    

    
}
