//
//  PhoneAuthViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/09.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class PhoneAuthViewController: BaseViewController {
    
    let authView = PhoneAuthView()
    
    override func loadView() {
        self.view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bindData() {
        //MARK: - 인증 문자 받기 버튼 클릭 시 인증 번호 입력 창으로 이동
        authView.authButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                Auth.auth().languageCode = "ko";
                PhoneAuthProvider.provider()
                    .verifyPhoneNumber("+82 \(vc.authView.phoneNumberText.text ?? "")", uiDelegate: nil) { (verificationID, error) in
                        if let error = error {
                            vc.showToast("에러 \(error.localizedDescription)")
                            return
                        }
                        if let id = verificationID {
                            UserDefaults.standard.set("\(id)", forKey: "verificationID")
                            vc.modalPresentationStyle = .overFullScreen
                            vc.present(PhoneInputViewController(), animated: true)
                        }
                    }
            }
            .disposed(by: authView.disposeBag)
    }
}


