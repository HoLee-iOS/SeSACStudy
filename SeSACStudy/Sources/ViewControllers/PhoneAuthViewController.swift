//
//  PhoneAuthViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/09.
//

import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa

class PhoneAuthViewController: BaseViewController {
    
    let authView = PhoneAuthView()
    
    let disposeBag = DisposeBag()
    
    let viewModel = PhoneAuthViewModel()
    
    override func loadView() {
        self.view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }    
}


