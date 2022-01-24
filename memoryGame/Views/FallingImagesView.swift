//
//  FallingImagesView.swift
//  Flush The Toilet
//
//  Created by Fanny Högberg on 2022-01-23.
//  Copyright © 2022 Fanny Högberg. All rights reserved.
//

import Foundation
import UIKit

class FallingImagesView: UIView {
    
    private var timer : Timer?
    private let images = CardBank()
    private var onAnimationDidComplete: EmptyAction?
    
    func clear() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    func playAnimation(imageSizeFactor: CGFloat = 0.33, completion: @escaping EmptyAction) {
        onAnimationDidComplete = completion
        let frameWidth = frame.width
        let imageWidth = frame.width * imageSizeFactor
        let halfImageWidth = imageWidth * 0.5
        let imageSize = CGSize(width: imageWidth, height: imageWidth)
        var imageXValue: CGFloat = -50
        var imageEndPosition = frame.height + halfImageWidth * 0.5
        
        var animateLeftToRight = true
        let distanceBetweenImages = imageWidth * 0.55

        timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { _ in
            
            if animateLeftToRight {
                imageXValue += distanceBetweenImages
            } else {
                imageXValue -= distanceBetweenImages
            }
            if imageXValue > frameWidth - halfImageWidth {
                imageEndPosition -= distanceBetweenImages
                animateLeftToRight = false
            }
            if imageXValue <= -halfImageWidth {
                imageEndPosition -= distanceBetweenImages
                animateLeftToRight = true
            }
            self.addNewImage(imageXValue: imageXValue, imageYEndPosition: imageEndPosition, imageSize: imageSize)
        }
    }
    }


private extension FallingImagesView {
    
    func addNewImage(imageXValue: CGFloat, imageYEndPosition: CGFloat, imageSize: CGSize){
        guard let randomImage = images.list.randomElement()?.image else { return }
        let imageStartPositionY = -imageSize.height
        let endPosition = imageYEndPosition
        let imageView = UIImageView(image: randomImage)
        
        let frame = CGRect(origin: CGPoint(x: imageXValue, y: imageStartPositionY), size: imageSize)
        imageView.frame = frame
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        let rotatedBy: CGFloat = drand48()-0.5
        imageView.transform = imageView.transform.rotated(by: rotatedBy)
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveLinear, animations: {
            imageView.frame.origin.y += CGFloat(endPosition)
        })
        
        if imageYEndPosition <= imageSize.height * 0.5 {
            animationDidComplete()
        }
    }
    
    func animationDidComplete() {
        timer?.invalidate()
        timer = nil
        onAnimationDidComplete?()
    }
}
