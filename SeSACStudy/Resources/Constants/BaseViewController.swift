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
        super.viewDidLoad()
        
        configure()
        setConstraints()
        bindData()
    }
    
    func configure() { }
    
    func setConstraints() { }
    
    func bindData() { }
    
    func showToast(_ message: String) {
        self.view.makeToast(message, position: .bottom)
    }
}
