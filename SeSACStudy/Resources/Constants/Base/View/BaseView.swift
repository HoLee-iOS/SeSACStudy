//
//  BaseView.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/09.
//

import UIKit
import Toast

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
    
    func showToast(_ message: String) {
        self.makeToast(message, position: .bottom)
    }
    
    //MARK: - 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
