//
//  NextLevelTransitionView.swift
//  Flush The Toilet
//
//  Created by Fanny Högberg on 2022-01-22.
//  Copyright © 2022 Fanny Högberg. All rights reserved.
//

import UIKit

class NextLevelTransitionView: UIView { //rename to masked something?
    
    init() {
        super.init(frame: .zero)
        addSubview(fallingImagesView, fill: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private lazy var animationMask: CALayer = {
        let mask = CALayer()
        let sizeOfMask = frame.size.height * 4
        mask.contents = UIImage(named: "toMask")!.cgImage
        mask.contentsGravity = kCAGravityResizeAspect
        mask.bounds = CGRect(x: 0, y: 0, width: sizeOfMask, height: sizeOfMask)
        mask.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        mask.position = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.47)
        return mask
    }()
    
    private let fallingImagesView = FallingImagesView()

    private lazy var label: UILabel = {
        let label = UILabel()
        addSubview(label)
        label.font = .systemFont(ofSize: 50)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 25),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        return label
    }()
    
    private var onAnimationDidComplete: EmptyAction?
}


// MARK: - Internal Functions

extension NextLevelTransitionView {
    
    func animateFallingImages(onComplete: @escaping EmptyAction) {
        fallingImagesView.isHidden = false
        fallingImagesView.playAnimation(completion: onComplete)
    }
    
    func clear() {
        clearViewAnimation()
    }
    
    func showTextAndHide(text: String, onComplete: @escaping EmptyAction) {
        onAnimationDidComplete = onComplete
        label.text = text
        label.alpha = 0
        label.isHidden = false
        UIView.animate(withDuration: 1) {
            self.label.alpha = 1
        } completion: { _ in
            self.animateMask()
        }
    }
}

// MARK: - Private Functions

private extension NextLevelTransitionView {
    
    func clearViewAnimation() {
        isHidden = true
        label.isHidden = true
        fallingImagesView.clear()
        layer.removeAllAnimations()
    }
}


// MARK: - CAAnimationDelegate

extension NextLevelTransitionView: CAAnimationDelegate {
    
    func animateMask() {
        layer.mask = animationMask
        let maskSizeMiddle = frame.size.width * 0.5
        let maskSizeMiddle2 = maskSizeMiddle * 2.5
        
        let animation = CAKeyframeAnimation(keyPath: "bounds")
        animation.delegate = self
        
        let start = animationMask.bounds
        let middle = CGRect(x: 0, y: 0, width: maskSizeMiddle, height: maskSizeMiddle)
        let middle2 = CGRect(x: 0, y: 0, width: maskSizeMiddle2, height: maskSizeMiddle2)
        let final = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        animation.values = [start, middle, middle2, final]
        animation.keyTimes = [0, 0.4,0.6, 1.0]
        animation.duration = 2.5
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        animation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)]
        
        animationMask.add(animation, forKey: "bounds")
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        onAnimationDidComplete?()
        clearViewAnimation()
        layer.mask = nil
    }
}
