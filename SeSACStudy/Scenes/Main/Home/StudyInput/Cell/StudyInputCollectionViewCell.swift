//
//  StudyInputCollectionViewCell.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/24.
//

import UIKit

import SnapKit

class StudyInputCollectionViewCell: BaseCollectionViewCell {
    
    private let tagButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: Fonts.regular, size: 14)
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
    
    func setCell(text: String?, indexPath: IndexPath) {
        tagButton.setTitle(text, for: .normal)

        tagButton.layer.borderColor = indexPath.section == 0 && (0...2).contains(indexPath.item) ? SystemColor.error.cgColor : GrayScale.gray4.cgColor
        tagButton.setTitleColor(indexPath.section == 0 && (0...2).contains(indexPath.item) ? SystemColor.error : BlackNWhite.black, for: .normal)
    }
}
