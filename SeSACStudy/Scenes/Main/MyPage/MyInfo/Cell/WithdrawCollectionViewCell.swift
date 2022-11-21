//
//  WithdrawCollectionViewCell.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/17.
//

import UIKit

class WithdrawCollectionViewCell: BaseCollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.medium, size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        label.attributedText = NSMutableAttributedString(string: "회원탈퇴", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()
    
    let withdrawButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    override func configure() {
        [titleLabel, withdrawButton].forEach{ contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.verticalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        withdrawButton.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
