//
//  UserCardTableViewCell.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/15.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class UserCardCollectionViewCell: BaseCollectionViewCell {
    
    let userCardLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.medium, size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        label.attributedText = NSMutableAttributedString(string: UserDefaultsManager.nickname, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()
    
    let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(Icons.moreView?.rotate(degrees: 90), for: .normal)
        return button
    }()
    
    override func configure() {
        [userCardLabel, moreButton].forEach{ contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        
        userCardLabel.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide).inset(28)
            $0.centerY.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.3)
        }
        
        moreButton.snp.makeConstraints {
            $0.centerY.equalTo(userCardLabel)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(28)
        }
    }
}
