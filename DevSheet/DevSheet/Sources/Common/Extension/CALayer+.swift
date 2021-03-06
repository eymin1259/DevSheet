//
//  CALayer+.swift
//  DevSheet
//
//  Created by yongmin lee on 5/24/22.
//

import UIKit

extension CALayer {
    func makeShadow(
        color: CGColor = UIColor.black.cgColor,
        alpha: Float = 0.5,
        offset: CGSize = .zero,
        blur: CGFloat = 1.0) {
        self.shadowColor = color
        self.shadowOpacity = alpha
        self.shadowOffset = offset
        self.shadowRadius = blur
    }
}
