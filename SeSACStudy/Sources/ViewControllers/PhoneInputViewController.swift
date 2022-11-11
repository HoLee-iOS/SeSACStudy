//
//  PhoneInputViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/10.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class PhoneInputViewController: BaseViewController {
    
    let customView = PhoneInputView()
    
    override func loadView() {
        self.view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bindData() {
        customView.authButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                //MARK: - 로그인을 할 FIRPhoneAuthCredential 객체 생성
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: UserDefaults.standard.string(forKey: "verificationID") ?? "",
                    verificationCode: vc.customView.authNumberText.text ?? ""
                )
                //MARK: - FIRPhoneAuthCredential 객체를 사용하여 로그인
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        vc.showToast("에러 \(error.localizedDescription)")
                        return
                    }
                    vc.showToast("로그인 성공 \(authResult)")
                }
            }
            .disposed(by: customView.disposeBag)
    }
}
