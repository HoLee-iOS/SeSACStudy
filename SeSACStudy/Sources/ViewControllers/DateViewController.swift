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
    
    override func bindData() {
        dateView.nextButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                if vc.dateView.nextButton.backgroundColor == GrayScale.gray6 {
                    vc.showToast("새싹스터디는 만 17세 이상만 사용할 수 있습니다.")
                } else {
                    UserDefaults.standard.setValue(vc.dateView.picker.date, forKey: "date")
                    vc.navigationController?.pushViewController(EmailViewController(), animated: true)
                }                
            }
            .disposed(by: dateView.disposeBag)
    }
}

