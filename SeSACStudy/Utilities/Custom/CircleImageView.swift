//
//  CircleImageView.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/15.
//

import UIKit

class CircleImageView: UIImageView {
    
    override init(image: UIImage?) {
        super.init(image: image)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        layer.borderColor = GrayScale.gray2.cgColor
        layer.borderWidth = 1
        contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        layer.masksToBounds = true
        layer.cornerRadius = self.bounds.height / 2
    }
}

