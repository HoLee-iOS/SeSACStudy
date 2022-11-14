//
//  LaunchViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/12.
//

import UIKit
import FirebaseAuth

class LaunchViewController: BaseViewController {
    
    let splash = SplashView()
    
    override func loadView() {
        self.view = splash
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bindData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.startVC()
        }
    }
    
    //MARK: - 스플래시에서 화면 분기처리
    func startVC() {
        if UserDefaultsManager.first {
            if UserDefaultsManager.token.isEmpty {
                self.setRootNavVC(vc: PhoneAuthViewController())
            } else {
                APIService.login { [weak self] (value, statusCode, error) in
                    guard let statusCode = statusCode else { return }
                    guard let networkErr = NetworkError(rawValue: statusCode) else { return }
                    switch networkErr {
                    case .success: self?.setRootVC(vc: MainTabBarController())
                    case .invalidToken: self?.refreshToken()
                    case .needSignUp: self?.setRootNavVC(vc: NicknameViewController())
                    default: return
                    }
                }
            }
        } else {
            self.setRootNavVC(vc: OnBoardingViewController())
        }
    }
    
    //MARK: - 토큰 만료 시 토큰 재발급
    func refreshToken() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { token, error in
            if let error = error as? NSError {
                guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
                switch errorCode {
                default: self.showToast("에러: \(error.localizedDescription)")
                }
                return
            } else if let token = token {
                UserDefaultsManager.token = token
                APIService.login { [weak self] (value, status, error) in
                    guard let status = status else { return }
                    guard let networkCode = NetworkError(rawValue: status) else { return }
                    switch networkCode {
                    case .success: self?.setRootVC(vc: MainTabBarController())
                    case .needSignUp: self?.setRootNavVC(vc: NicknameViewController())
                    default: return
                    }
                }
            }
        }
    }
}
