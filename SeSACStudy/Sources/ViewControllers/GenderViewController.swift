//
//  GenderViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/11.
//

import Foundation

class GenderViewController: BaseViewController {
    
    let genderView = GenderView()
    
    override func loadView() {
        self.view = genderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bindData() {
        genderView.nextButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                
            }
            .disposed(by: genderView.disposeBag)
    }
}
