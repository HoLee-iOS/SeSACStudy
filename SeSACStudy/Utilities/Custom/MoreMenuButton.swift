//
//  MoreMenuButton.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/04.
//

import UIKit

class MoreMenuButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(text: String, image: UIImage?, type: MoreMenuTap) {
        self.init(frame: .zero)
        configure(text: text, image: image, type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String, image: UIImage?, type: MoreMenuTap) {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString.init(text)
        config.attributedTitle?.font = UIFont(name: Fonts.regular, size: 14)
        config.attributedTitle?.foregroundColor = BlackNWhite.black
        config.image = image
        config.imagePlacement = .top
        config.imagePadding = 4
        self.configuration = config
    }
}
