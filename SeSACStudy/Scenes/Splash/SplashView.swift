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
        logoImage.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(78)
            make.bottom.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.63)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.4)
        }
        
        txtImage.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.top.equalTo(logoImage.snp.bottom)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.2)
        }
    }
}
