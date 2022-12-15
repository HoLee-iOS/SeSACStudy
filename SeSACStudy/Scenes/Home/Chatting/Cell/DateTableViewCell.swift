//
//  DateTableViewCell.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/01.
//

import UIKit

import SnapKit

class DateTableViewCell: BaseTableViewCell {
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 20
        label.backgroundColor = GrayScale.gray7
        label.textColor = BlackNWhite.white
        label.textAlignment = .center
        label.font = UIFont(name: Fonts.medium, size: 12)
        return label
    }()
    
    let chatInfoView: UIView = {
        let view = UIView()
        return view
    }()
    
    let matchingInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = GrayScale.gray7
        label.font = UIFont(name: Fonts.medium, size: 14)
        return label
    }()
    
    let bellIcon: UIImageView = {
        let image = UIImageView()
        image.image = Icons.Chat.bell
        image.contentMode = .scaleAspectFit
        image.tintColor = GrayScale.gray7
        return image
    }()
    
    let chattingInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = GrayScale.gray6
        label.text = TextCase.Chatting.chatInfo.rawValue
        label.font = UIFont(name: Fonts.regular, size: 14)
        return label
    }()
    
    override func configure() {
        [matchingInfoLabel, bellIcon, chattingInfoLabel].forEach{ chatInfoView.addSubview($0) }
        [dateLabel, chatInfoView].forEach{ contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(16)
            $0.width.equalTo(contentView.snp.width).multipliedBy(0.3)
            $0.height.equalTo(contentView.snp.height).multipliedBy(0.35)
            $0.centerX.equalTo(contentView)
        }
        
        matchingInfoLabel.snp.makeConstraints {
            $0.top.equalTo(chatInfoView).inset(12)
            $0.centerX.equalTo(chatInfoView).offset(16)
        }
        
        bellIcon.snp.makeConstraints {
            $0.top.equalTo(chatInfoView).inset(12)
            $0.trailing.equalTo(matchingInfoLabel.snp.leading).offset(-4)
            $0.size.equalTo(matchingInfoLabel.snp.height)
        }
        
        chattingInfoLabel.snp.makeConstraints {
            $0.top.equalTo(matchingInfoLabel.snp.bottom).offset(2)
            $0.centerX.equalTo(chatInfoView)
            $0.bottom.equalTo(chatInfoView).offset(-12)
        }
        
        chatInfoView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom)
            $0.horizontalEdges.equalTo(contentView).inset(16)
            $0.height.equalTo(contentView).multipliedBy(0.6)
        }
    }
    
}
