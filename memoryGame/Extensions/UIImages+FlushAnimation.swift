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
    
    static let flushAnimation: [UIImage] = {
        
        let part1: [UIImage] = (1...6).compactMap { _ in .toiletImage(number: 1) }
        let part2 = toiletImages(startIndex: 1, endIndex: 3)
        let part3 = part2.reversed()
        let part4: [UIImage] = [.toiletImage(number: 4),
                                .toiletImage(number: 5),
                                .toiletImage(number: 4)].compactMap { $0 }
        let part5 = toiletImages(startIndex: 6, endIndex: 8)
        let part6 = part5.reversed()
        return part1 + part2 + part3 + part4 + part5 + part6
    }()
    
    
    static private func toiletImages(startIndex: Int, endIndex: Int) -> [UIImage] {
        (startIndex...endIndex).compactMap { .toiletImage(number: $0) }
    }
}

private extension UIImage {
        
    static func toiletImage(number: Int) -> UIImage? {
        UIImage(named: "toiletBottom\(number)")
    }
}
