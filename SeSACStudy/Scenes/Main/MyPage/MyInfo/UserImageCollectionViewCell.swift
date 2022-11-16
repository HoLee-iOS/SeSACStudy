//
//  UserImageCollectionViewCell.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/15.
//

import UIKit
import SnapKit

final class UserImageCollectionViewCell: BaseCollectionViewCell {
    
    lazy var cardHeader: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 8
        self.addSubview(image)
        return image
    }()
    
    override func setConstraints() {
        cardHeader.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(self.safeAreaLayoutGuide)
            make.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(1.1)
        }
    }
}
