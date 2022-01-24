//
//  UIImages+FlushAnimation.swift
//  Flush The Toilet
//
//  Created by Fanny Högberg on 2022-01-25.
//  Copyright © 2022 Fanny Högberg. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element == UIImage {
    
    static let eyeAnimation: [UIImage] = {
        let array = (1...6).compactMap { UIImage(named: "cardBack\($0)") }
        let reversed = array.reversed()
        return array + reversed
    }()
}
