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
        showToast("인증번호를 보냈습니다.")
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
                    if let error = error as NSError? {
                        guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
                        switch errorCode {
                        case .sessionExpired, .invalidVerificationCode:
                            vc.showToast("전화 번호 인증 실패")
                        default:
                            vc.showToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                        }
                        return
                    }
                    authResult?.user.getIDToken { token, error in
                        if let error = error {
                            vc.showToast("에러: \(error.localizedDescription)")
                        }

                        guard let token = token else { return }
                        UserDefaults.standard.setValue(token, forKey: "token")
                        APIService.login(idToken: token) { value, statusCode, error in
                            guard let statusCode = statusCode else { return }
                            switch statusCode {
                            case 200: vc.showToast("로그인 성공")
                            case 406: vc.navigationController?.pushViewController(NicknameViewController(), animated: true)
                            default: vc.showToast("기타 오류")
                            }
                        }
                    }
                }
            }
            .disposed(by: customView.disposeBag)
        
        customView.resendButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.showToast("전화 번호 인증 시작")
                Auth.auth().languageCode = "ko"
                PhoneAuthProvider.provider()
                    .verifyPhoneNumber(UserDefaults.standard.string(forKey: "phoneNum") ?? "", uiDelegate: nil) { (verificationID, error) in
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
                        UserDefaults.standard.set("\(id)", forKey: "verificationID")
                    }
            }
            .disposed(by: customView.disposeBag)
    }
}
