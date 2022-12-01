//
//  UIButton + Extensions.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/22.
//

import UIKit

extension UIButton {
    enum VerticalLocation {
        case bottom
        case top
        case left
        case right
    }

    func addShadow(location: VerticalLocation, color: UIColor = BlackNWhite.black, opacity: Float = 0.5, radius: CGFloat = 0.5) {
        switch location {
        case .bottom:
             addShadow(offset: CGSize(width: 0, height: 1), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -1), color: color, opacity: opacity, radius: radius)
        case .left:
            addShadow(offset: CGSize(width: -1, height: 0), color: color, opacity: opacity, radius: radius)
        case .right:
            addShadow(offset: CGSize(width: 0.5, height: 0), color: color, opacity: opacity, radius: radius)
        }
    }

    func addShadow(offset: CGSize, color: UIColor = BlackNWhite.black, opacity: Float = 0.1, radius: CGFloat = 3.0) { 
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}
