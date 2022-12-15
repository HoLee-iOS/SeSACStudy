//
//  ReviewButton.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/04.
//

import UIKit

import RxSwift
import RxCocoa

class ReviewButton: UIButton {
    
    let disposeBag = DisposeBag()
    
    var tapped = false
    
    var config = UIButton.Configuration.plain()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ text: String, type: ReviewCase) {
        self.init(frame: .zero)
        configure(text, type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ text: String, type: ReviewCase) {
        tag = type.rawValue
        config.attributedTitle = AttributedString.init(text)
        config.attributedTitle?.font = UIFont(name: Fonts.regular, size: 14)
        config.attributedTitle?.foregroundColor = BlackNWhite.black
        config.background.backgroundColor = BlackNWhite.white
        layer.cornerRadius = 8
        layer.borderColor = GrayScale.gray4.cgColor
        layer.borderWidth = 1
        self.configuration = config
        
        self.rx.tap
            .withUnretained(self)
            .bind { (btn, _) in
                btn.tapped.toggle()
                
                if btn.tapped {
                    btn.config.attributedTitle?.foregroundColor = BlackNWhite.white
                    btn.config.background.backgroundColor = BrandColor.green
                    btn.configuration = btn.config
                    ChatDataModel.shared.reputation[btn.tag] = 1
                } else {
                    btn.config.attributedTitle?.foregroundColor = BlackNWhite.black
                    btn.config.background.backgroundColor = BlackNWhite.white
                    btn.configuration = btn.config
                    ChatDataModel.shared.reputation[btn.tag] = 0
                }
            }
            .disposed(by: disposeBag)
    }
}
