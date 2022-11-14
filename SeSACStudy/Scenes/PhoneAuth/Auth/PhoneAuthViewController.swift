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
            .bind { (vc, _ ) in
                //MARK: - 유효하지 않은 형식
                if vc.authView.authButton.backgroundColor == GrayScale.gray6 {
                    vc.showToast("잘못된 전화번호 형식입니다.")
                    //MARK: - 유효한 형식
                } else {
                    vc.showToast("전화 번호 인증 시작")
                    Auth.auth().languageCode = "ko"
                    PhoneAuthProvider.provider()
                        .verifyPhoneNumber(vc.authView.phoneNumberText.text?.removeHypen() ?? "", uiDelegate: nil) { (verificationID, error) in
                            if let error = error as NSError? {
                                guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
                                switch errorCode {
                                case .tooManyRequests:
                                    vc.showToast("과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요.")
                                default:
                                    vc.showToast("에러가 발생했습니다. 다시 시도해주세요.")
                                }
                                return
                            }
                            guard let id = verificationID else { return }
                            UserDefaultsManager.phoneNum = vc.authView.phoneNumberText.text?.removeHypen() ?? ""
                            UserDefaultsManager.verificationID = id
                            vc.navigationController?.pushViewController(PhoneInputViewController(), animated: true)
                            
                        }
                }
            }
            .disposed(by: authView.disposeBag)
    }
}
