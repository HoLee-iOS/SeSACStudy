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
        
        emailView.nextButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                if vc.emailView.nextButton.backgroundColor == GrayScale.gray6 {
                    vc.showToast("이메일 형식이 올바르지 않습니다.")
                } else {
                    UserDefaultsManager.email = vc.emailView.emailText.text ?? ""
                    vc.navigationController?.pushViewController(GenderViewController(), animated: true)
                }                
            }
            .disposed(by: emailView.disposeBag)
    }
}
