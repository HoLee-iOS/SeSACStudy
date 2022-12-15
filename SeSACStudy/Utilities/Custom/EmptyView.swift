//
//  EmptyView.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/25.
//

import UIKit

import SnapKit

class EmptyView: BaseView {
    
    let sesacImage: UIImageView = {
        let image = UIImageView()
        image.image = Icons.sesacEmpty
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = BlackNWhite.black
        label.font = UIFont(name: Fonts.regular, size: 20)
        label.textAlignment = .center
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.text = "스터디를 변경하거나 조금만 더 기다려 주세요!"
        label.textColor = GrayScale.gray7
        label.font = UIFont(name: Fonts.regular, size: 14)
        label.textAlignment = .center
        return label
    }()
    
    let changeButton: UIButton = {
        let button = UIButton()
        let attributedText = NSMutableAttributedString(string: "스터디 변경하기", attributes: [NSAttributedString.Key.font: UIFont(name: Fonts.regular, size: 16)!, NSAttributedString.Key.foregroundColor: BlackNWhite.white])
        button.setAttributedTitle(attributedText, for: .normal)
        button.backgroundColor = BrandColor.green
        button.layer.cornerRadius = 8
        return button
    }()
    
    let refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(Icons.refresh, for: .normal)
        button.backgroundColor = BlackNWhite.white
        button.layer.borderColor = BrandColor.green.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func configure() {
        [refreshButton, changeButton, mainLabel, subLabel, sesacImage].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        refreshButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.07)
            $0.width.equalTo(refreshButton.snp.height)
        }
        
        changeButton.snp.makeConstraints {
            $0.leading.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            $0.trailing.equalTo(refreshButton.snp.leading).offset(-8)
            $0.height.equalTo(refreshButton.snp.height)
        }
        
        mainLabel.snp.makeConstraints {
            $0.center.equalTo(safeAreaLayoutGuide)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(8)
            $0.centerX.equalTo(safeAreaLayoutGuide)
        }

        sesacImage.snp.makeConstraints {
            $0.bottom.equalTo(mainLabel.snp.top).offset(-44)
            $0.width.equalTo(safeAreaLayoutGuide).multipliedBy(0.3)
            $0.centerX.equalTo(safeAreaLayoutGuide)
        }
    }
}
