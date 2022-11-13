//
//  BaseViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/09.
//

import UIKit
import Toast

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        configure()
        setConstraints()
        bindData()
    }
    
    func configure() { }
    
    func setConstraints() { }
    
    func bindData() { }
    
    //MARK: - 토스트 메시지 설정
    func showToast(_ message: String) {
        self.view.makeToast(message, position: .top)
    }
}
