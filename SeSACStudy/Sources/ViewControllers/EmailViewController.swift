//
//  EmailViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/11.
//

import Foundation

class EmailViewController: BaseViewController {
    
    let emailView = EmailView()
    
    override func loadView() {
        self.view = emailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
