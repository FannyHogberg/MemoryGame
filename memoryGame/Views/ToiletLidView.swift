//
//  ToiletLidView.swift
//  Flush The Toilet
//
//  Created by Fanny Högberg on 2022-01-25.
//  Copyright © 2022 Fanny Högberg. All rights reserved.
//

import Foundation
import UIKit

class ToiletLidView: UIView {
    
    func openLid() {
        layer.add(animation, forKey: nil)
    }
}

private extension ToiletLidView {
    
    var animation: CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 1
        animation.repeatCount = 1
        animation.fromValue = layer.presentation()?.value(forKeyPath: "transform.rotation")
        animation.toValue = Double.pi * -0.5
        animation.autoreverses = true
        return animation
    }
}
