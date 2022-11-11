//
//  DateViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/10.
//

import UIKit

class DateViewController: BaseViewController {
    
    let dateView = DateView()
    
    override func loadView() {
        self.view = dateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

