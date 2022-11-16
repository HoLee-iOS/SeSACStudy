//
//  MyNameTableViewCell.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/15.
//

import UIKit
import SnapKit

final class MyNameTableViewCell: BaseTableViewCell {
    
    let cellImage: CircleImageView = {
        let image = CircleImageView(image: nil)
        return image
    }()
    
    let cellTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.medium, size: 16)
        return label
    }()
    
    let moreViewImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override func configure() {
        [cellImage, cellTitle, moreViewImage].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        cellImage.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.5)
            make.width.equalTo(cellImage.snp.height)
        }
        
        cellTitle.snp.makeConstraints { make in
            make.leading.equalTo(cellImage.snp.trailing).offset(20)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
        }
        
        moreViewImage.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.4)
            make.width.equalTo(moreViewImage.snp.height).multipliedBy(0.5)
        }
    }
}

