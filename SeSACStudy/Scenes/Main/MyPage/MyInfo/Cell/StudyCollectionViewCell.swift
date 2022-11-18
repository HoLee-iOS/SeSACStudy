//
//  StudyCollectionViewCell.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/17.
//

import UIKit
import SnapKit

class StudyCollectionViewCell: BaseCollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.medium, size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        label.attributedText = NSMutableAttributedString(string: "자주 하는 스터디", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()
    
    let studyInfo: UITextField = {
        let text = UITextField()
        text.placeholder = "스터디를 입력해 주세요"
        return text
    }()
    
    let textline: UIView = {
        let line = UIView()
        line.backgroundColor = GrayScale.gray3
        return line
    }()
    
    override func configure() {
        [titleLabel, studyInfo, textline].forEach{ contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.verticalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        textline.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(titleLabel.snp.bottom).offset(-8)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            $0.width.equalTo(safeAreaLayoutGuide).multipliedBy(0.5)
        }
        
        studyInfo.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.centerY.equalTo(titleLabel)
            $0.centerX.equalTo(textline.snp.centerX).offset(8)
            $0.trailing.equalTo(textline.snp.trailing)
        }        
    }
}
