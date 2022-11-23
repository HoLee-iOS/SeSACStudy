//
//  GenderViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/11.
//

import UIKit
import FirebaseAuth
import Toast

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
                if vc.genderView.nextButton.backgroundColor == GrayScale.gray6 {
                    vc.showToast("성별을 선택해주세요.")
                } else {
                    //MARK: - 회원가입 API 요청
                    APIService.signUp { value, statusCode, error in
                        guard let statusCode = statusCode else { return }
                        guard let networkErr = NetworkError(rawValue: statusCode) else { return }
                        switch networkErr {
                        case .success: vc.view.makeToast("회원가입 성공", position: .top) { _ in vc.setRootVC(vc: MainTabBarController()) }
                        case .invalidNick: vc.view.makeToast("사용할 수 없는 닉네임입니다.", position: .top) { _ in vc.backTo() }
                        case .invalidToken: vc.refreshToken()
                        default: vc.showToast("잠시 후 다시 시도해 주세요.")
                        }
                    }
                }
            }
            .disposed(by: genderView.disposeBag)
    }
    
    //MARK: - 유효한 닉네임이 아닐 시에 닉네임 화면으로 팝 시킴
    func backTo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
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
                APIService.signUp { [weak self] (value, status, error) in
                    guard let status = status else { return }
                    guard let networkCode = NetworkError(rawValue: status) else { return }
                    switch networkCode {
                    case .success: self?.view.makeToast("회원가입 성공", position: .top) { _ in self?.setRootVC(vc: MainTabBarController()) }
                    default: self?.showToast("잠시 후 다시 시도해 주세요.")
                    }
                }
            }
        }
    }
}
