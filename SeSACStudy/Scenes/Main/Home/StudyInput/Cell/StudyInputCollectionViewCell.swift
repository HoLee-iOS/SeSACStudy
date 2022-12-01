//
//  StudyInputCollectionViewCell.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/24.
//

import UIKit

import SnapKit

class StudyInputCollectionViewCell: BaseCollectionViewCell {
    
    let tagButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        button.titleLabel?.font = UIFont(name: Fonts.regular, size: 14)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        config.contentInsets = .init(top: 5, leading: 16, bottom: 5, trailing: 16)
        button.configuration = config
        return button
    }()
    
    override func configure() {
        contentView.addSubview(tagButton)
    }
    
    override func setConstraints() {
        tagButton.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide).inset(4)
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: tagButton.intrinsicContentSize.width + 20, height: 44)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    
    func setCell(text: String?, indexPath: IndexPath) {
        tagButton.setTitle(text, for: .normal)
        
        if indexPath.section == 0 {
            if indexPath.item < TagList.redTags.count {
                tagButton.layer.borderColor = SystemColor.error.cgColor
                tagButton.setTitleColor(SystemColor.error, for: .normal)
            } else {
                tagButton.layer.borderColor = GrayScale.gray4.cgColor
                tagButton.setTitleColor(BlackNWhite.black, for: .normal)
            }
        } else {
            tagButton.layer.borderColor = BrandColor.green.cgColor
            tagButton.setTitleColor(BrandColor.green, for: .normal)
            tagButton.configuration?.image = Icons.closeSmall
            tagButton.configuration?.imagePlacement = .trailing
            tagButton.configuration?.imagePadding = 6
            tagButton.tintColor = BrandColor.green
        }
    }
}
