//
//  PipeImageView.swift
//  Flush The Toilet
//
//  Created by Fanny Högberg on 2022-01-25.
//  Copyright © 2022 Fanny Högberg. All rights reserved.
//

import UIKit

class PipeImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

private extension PipeImageView {
    
    var animation: [UIImage] {
        let array = (1...4).compactMap { UIImage(named: "pipe\($0)") }
        let reversed = array.reversed()
        return array + reversed
    }
    
    func setup() {
        image = UIImage(named: "pipe1")
        
        animationImages = animation
        animationDuration = 0.3
        animationRepeatCount = 1
    }
}
