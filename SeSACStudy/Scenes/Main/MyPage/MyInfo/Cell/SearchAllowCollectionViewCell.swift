//
//  SearchAllowCollectionViewCell.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/17.
//

import UIKit

class SearchAllowCollectionViewCell: BaseCollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.medium, size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        label.attributedText = NSMutableAttributedString(string: "내 번호 검색 허용", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()
    
    let searchSwitch: UISwitch = {
        let onoff = UISwitch()
        onoff.onTintColor = BrandColor.green
        return onoff
    }()
    
    override func configure() {
        [titleLabel, searchSwitch].forEach{ contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.verticalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        searchSwitch.snp.makeConstraints {
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            $0.centerY.equalTo(titleLabel)
        }
    }
    
}
