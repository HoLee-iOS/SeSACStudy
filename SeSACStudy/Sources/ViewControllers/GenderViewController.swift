//
//  GenderViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/11.
//

import Foundation
import FirebaseAuth

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
                        print(statusCode)
                        switch statusCode {
                        case 200: vc.showToast("회원가입 성공")
                        case 201: vc.showToast("이미 가입한 유저")
                        case 202: vc.showToast("사용할 수 없는 닉네임")
                        case 401: vc.refreshToken()
                        case 500: vc.showToast("서버 에러")
                        case 501: vc.showToast("API 요청 값 에러")
                        default: vc.showToast("기타 오류")
                        }
                    }
                }
            }
            .disposed(by: genderView.disposeBag)
    }
    
    //MARK: - 토큰 만료로 인한 재발급
    func refreshToken() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { token, error in
            if let error = error {
                self.showToast("에러: \(error.localizedDescription)")
                return
            } else if let token = token {
                UserDefaultsManager.token = token
                APIService.login { [weak self] value, statusCode, error in
                    guard let statusCode = statusCode else { return }
                    switch statusCode {
                    case 200: self?.showToast("로그인 성공")
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
