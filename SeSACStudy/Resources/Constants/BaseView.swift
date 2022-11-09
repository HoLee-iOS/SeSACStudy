//
//  BaseView.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/09.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = BlackNWhite.white
        configure()
        setConstraints()
        bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() { }
    
    func setConstraints() { }
    
    func bindData() { }
}
