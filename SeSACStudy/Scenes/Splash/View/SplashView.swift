//
//  SplashView.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/12.
//

import UIKit
import SnapKit

class SplashView: BaseView {
    
    let logoImage: UIImageView = {
        let image = UIImageView()
        image.image = Icons.splashLogo
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let txtImage: UIImageView = {
        let image = UIImageView()
        image.image = Icons.splashTxt
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override func configure() {
        [logoImage, txtImage].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        logoImage.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(78)
            $0.bottom.equalTo(safeAreaLayoutGuide).multipliedBy(0.63)
            $0.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.4)
        }
        
        txtImage.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.top.equalTo(logoImage.snp.bottom)
            $0.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.2)
        }
    }
}
