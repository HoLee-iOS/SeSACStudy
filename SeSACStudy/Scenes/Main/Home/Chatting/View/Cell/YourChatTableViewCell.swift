//
//  YourChatTableViewCell.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/01.
//

import UIKit

import SnapKit

class YourChatTableViewCell: BaseTableViewCell {
 
    let chatBox: BasePaddingLabel = {
        let label = BasePaddingLabel()
        label.numberOfLines = 0
        label.layer.cornerRadius = 8
        label.layer.borderColor = GrayScale.gray4.cgColor
        label.layer.borderWidth = 1
        label.font = UIFont(name: Fonts.regular, size: 14)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = GrayScale.gray6
        label.font = UIFont(name: Fonts.regular, size: 12)
        return label
    }()
    
    let talkBubble: UIView = {
        let view = UIView()
        return view
    }()
    
    override func configure() {
        [chatBox, timeLabel].forEach{ talkBubble.addSubview($0) }
        contentView.addSubview(talkBubble)
    }
    
    override func setConstraints() {
        chatBox.snp.makeConstraints {
            $0.leading.verticalEdges.equalTo(talkBubble)
            $0.trailing.lessThanOrEqualTo(talkBubble).inset(48)
        }
        
        timeLabel.snp.makeConstraints {
            $0.bottom.equalTo(chatBox.snp.bottom)
            $0.leading.equalTo(chatBox.snp.trailing).offset(8)
        }
        
        talkBubble.snp.makeConstraints {
            $0.leading.verticalEdges.equalTo(contentView).inset(16)
            $0.trailing.equalTo(contentView).inset(57)
        }
    }    
}
