//
//  MyPageTableViewCell.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/14.
//

import UIKit
import SnapKit

final class MyPageTableViewCell: BaseTableViewCell {
    
    let cellImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let cellTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.regular, size: 16)
        return label
    }()
    
    override func configure() {
        [cellImage, cellTitle].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        cellImage.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.3)
            make.width.equalTo(cellImage.snp.height)
        }
        
        cellTitle.snp.makeConstraints { make in
            make.leading.equalTo(cellImage.snp.trailing).offset(20)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
