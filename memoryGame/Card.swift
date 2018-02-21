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
    let soundFileName : String
    var isFlipped : Bool = false
    
    
    init(cardId: String, imageName: String, soundName: String) {
        id = cardId
        image = UIImage(named: imageName)!
        soundFileName = soundName

    }

    
    func setIsFlipped(status: Bool){
        isFlipped = status
    }
    

    
}
