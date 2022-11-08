//
//  PageContentsViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/09.
//

import UIKit
import SnapKit

final class PageContentsViewController: UIViewController {
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.backgroundColor = BrandColor.green
        button.setTitleColor(BlackNWhite.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.medium, size: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [startButton, imageView, label].forEach { view.addSubview($0) }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(48)
        }
        
        imageView.snp.makeConstraints { make in
            make.bottom.equalTo(startButton.snp.top).offset(-60)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        label.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.top).offset(-40)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(85)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
        }
    }
}
