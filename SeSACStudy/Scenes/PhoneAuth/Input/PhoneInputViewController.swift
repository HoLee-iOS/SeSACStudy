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
        showToast("인증번호를 보냈습니다.")
        
        customView.authButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { (vc, _) in
                UserDefaultsManager.verificationCode = vc.customView.authNumberText.text ?? ""
                //MARK: - 로그인을 할 FIRPhoneAuthCredential 객체 생성
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: UserDefaultsManager.verificationID,
                    verificationCode: UserDefaultsManager.verificationCode
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
                    //MARK: - ID 토큰 발급
                    authResult?.user.getIDToken { token, error in
                        if let error = error {
                            vc.showToast("에러: \(error.localizedDescription)")
                            return
                        }
                        guard let token = token else { return }
                        //MARK: - 로그인 API 요청
                        UserDefaultsManager.token = token
                        APIService.login { value, statusCode, error in
                            guard let statusCode = statusCode else { return }
                            switch statusCode {
                            case 200: vc.view.makeToast("로그인 성공", position: .top) { _ in vc.setRootVC(vc: MainTabBarController()) }
                            case 401: vc.refreshToken()
                            case 406: vc.navigationController?.pushViewController(NicknameViewController(), animated: true)
                            case 500: vc.showToast("서버 오류")
                            case 501: vc.showToast("잘못된 요청")
                            default: vc.showToast("기타 오류")
                            }
                        }
                    }
                }
            }
            .disposed(by: customView.disposeBag)
        
        //MARK: - 재전송 기능 구현
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
                        UserDefaultsManager.verificationID = id
                    }
            }
            .disposed(by: customView.disposeBag)
    }
    
    //MARK: - 토큰 만료 시 토큰 재발급
    func refreshToken() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { token, error in
            if let error = error {
                self.showToast("에러: \(error.localizedDescription)")
                return
            } else if let token = token {
                UserDefaultsManager.token = token
                APIService.login { [weak self] (value, status, error) in
                    guard let status = status else { return }
                    switch status {
                    case 200: self?.view.makeToast("로그인 성공", position: .top, completion: { _ in self?.setRootVC(vc: MainTabBarController()) })
                    case 401: self?.showToast("토큰 만료")
                    case 406: self?.navigationController?.pushViewController(NicknameViewController(), animated: true)
                    case 500: self?.showToast("서버 오류")
                    case 501: self?.showToast("잘못된 요청")
                    default: self?.showToast("기타 오류")
                    }
                }
            }
        }
    }
}
