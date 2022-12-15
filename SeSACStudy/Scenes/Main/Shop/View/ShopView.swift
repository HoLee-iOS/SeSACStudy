//
//  ShopView.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/13.
//

import UIKit

class ShopView: BaseView {
    
    lazy var cardBackground: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        image.image = Icons.sesacBack9
        return image
    }()
    
    lazy var cardHeader: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 8
        image.image = Icons.sesacFace5
        return image
    }()
    
    let requestButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        button.layer.cornerRadius = 8
        config.contentInsets = .init(top: 9, leading: 14, bottom: 9, trailing: 14)
        config.title = "저장하기"
        config.background.backgroundColor = BrandColor.green
        config.baseForegroundColor = BlackNWhite.white
        button.configuration = config
        return button
    }()
    
    override func configure() {
        [cardBackground, cardHeader, requestButton].forEach{ addSubview($0) }
    }
    
    override func setConstraints() {
        cardBackground.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        cardHeader.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(safeAreaLayoutGuide)
            $0.centerY.equalTo(safeAreaLayoutGuide).multipliedBy(1.1)
        }
        
        requestButton.snp.makeConstraints {
            $0.top.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(cardHeader.safeAreaLayoutGuide).multipliedBy(0.15)
            $0.width.equalTo(requestButton.snp.height).multipliedBy(2)
        }
    }
    
}
