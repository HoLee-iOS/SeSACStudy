//
//  ThumbButton.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/18.
//

import UIKit

class ThumbButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = BrandColor.green
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = BrandColor.green
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}
