//
//  UserImageCollectionViewCell.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/15.
//

import UIKit
import SnapKit

final class UserImageCollectionViewCell: BaseCollectionViewCell {
    
    lazy var cardHeader: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 8
        return image
    }()
    
    let requestButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: Fonts.medium, size: 14)
        button.layer.cornerRadius = 8
        button.backgroundColor = SystemColor.error
        return button
    }()
    
    override func configure() {
        [cardHeader, requestButton].forEach{ contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        cardHeader.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(self.safeAreaLayoutGuide)
            $0.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(1.1)
        }
        
        requestButton.snp.makeConstraints {
            $0.top.trailing.equalTo(safeAreaLayoutGuide).inset(28)
            $0.height.equalTo(cardHeader.safeAreaLayoutGuide).multipliedBy(0.15)
            $0.width.equalTo(requestButton.snp.height).multipliedBy(2)
        }
    }
}
