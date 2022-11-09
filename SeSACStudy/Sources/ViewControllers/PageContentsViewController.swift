//
//  PageContentsViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/09.
//

import UIKit
import SnapKit

final class PageContentsViewController: UIViewController {

    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.medium, size: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [label, imageView].forEach { view.addSubview($0) }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
    }
}
