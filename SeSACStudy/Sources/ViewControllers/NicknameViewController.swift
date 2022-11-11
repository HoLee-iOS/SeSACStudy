//
//  NicknameViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/10.
//

import UIKit

class NicknameViewController: BaseViewController {
    
    let nicknameView = NicknameView()
    
    override func loadView() {
        self.view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
