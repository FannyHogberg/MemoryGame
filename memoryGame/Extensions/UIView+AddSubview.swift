//
//  UIView+AddSubview.swift
//  Flush The Toilet
//
//  Created by Fanny Högberg on 2022-01-23.
//  Copyright © 2022 Fanny Högberg. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addSubview(_ subview: UIView, fill: Bool) {
        if fill {
            addSubview(subview, margins: .zero)
        } else {
            addSubview(subview)
        }
    }
    
    func addSubview(_ subview: UIView, margins: UIEdgeInsets) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margins.left),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margins.right),
            subview.topAnchor.constraint(equalTo: topAnchor, constant: margins.top),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margins.bottom)
        ])
    }
}
