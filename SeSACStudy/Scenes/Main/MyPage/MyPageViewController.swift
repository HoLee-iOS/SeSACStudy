//
//  MyPageViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/14.
//

import UIKit

class MyPageViewController: BaseViewController {
    
    let myPageView = MyPageView()
    
    override func loadView() {
        self.view = myPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
}
