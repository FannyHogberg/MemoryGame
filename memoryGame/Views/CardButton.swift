//
//  CardButton.swift
//  Flush The Toilet
//
//  Created by Fanny Högberg on 2022-01-24.
//  Copyright © 2022 Fanny Högberg. All rights reserved.
//

import Foundation
import UIKit

class CardButton: UIButton {
    
    var card: Card?
    var isFlipped: Bool { card?.isFlipped ?? false }
    
    private let notFlippedImage = UIImage(named: "cardBack1")
    private var animationEnabled = false
    
    // MARK: - Override
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        setup()
    }
    
    
    // MARK: - Internal Functions
    
    func flipToBack() {
        guard isFlipped else { return }
        card?.flipCard()
        setImage(notFlippedImage, for: .normal)
        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromRight, animations: nil)
            animationEnabled = true
    }
    
    func flipToFront() {
        guard !isFlipped else { return }
        animationEnabled = false
        card?.flipCard()
        let image = card?.image
        setImage(image, for: .normal)
        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromLeft, animations: nil)
    }
    
    func reset() {
        setImage(notFlippedImage, for: .normal)
        transform = CGAffineTransform.identity
    }
    
    func setupWith(_ card: Card) {
        self.card = card
    }
    
    func shake() {
        layer.removeAllAnimations()
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromValue = NSValue(cgPoint: CGPoint(x: center.x - 5, y: center.y - 5))
        let toValue = NSValue(cgPoint: CGPoint(x: center.x + 5, y: center.y + 5))
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: nil)
    }
    
    func startEyeAnimation() {
        guard animationEnabled else { return }
        imageView?.startAnimating()
    }
    
    func stopEyeAnimation() {
        imageView?.stopAnimating()
    }
}


// MARK: - Private Functions

private extension CardButton {
    
    func setup() {
        adjustsImageWhenDisabled = false
        imageView?.contentMode = .scaleAspectFit
        imageView?.animationImages = .eyeAnimation
        imageView?.animationRepeatCount = 1
        imageView?.animationDuration = 0.5
    }
}
