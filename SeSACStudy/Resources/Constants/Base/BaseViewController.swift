//
//  BaseViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/09.
//

import UIKit
import Toast
import FirebaseAuth

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        self.view.backgroundColor = BlackNWhite.white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        configure()
        setConstraints()
        bindData()
    }
    
    func configure() { }
    
    func setConstraints() { }
    
    func bindData() { }
    
    //MARK: - 토스트 메시지 설정
    func showToast(_ message: String) {
        self.view.makeToast(message, position: .top)
    }
    
    //MARK: - 네비게이션 루트뷰 설정
    func setRootNavVC(vc: UIViewController) {
        let navigationVC = UINavigationController(rootViewController: vc)
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        guard let delegate = sceneDelegate else { return }
        delegate.window?.rootViewController = navigationVC
    }
    
    //MARK: - 루트뷰 설정
    func setRootVC(vc: UIViewController) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    //MARK: - 토큰 만료 시 재발급
//    func refreshToken(completion: @escaping () -> Void) {
//        let currentUser = Auth.auth().currentUser
//        currentUser?.getIDTokenForcingRefresh(true) { token, error in
//            if let error = error as? NSError {
//                guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
//                switch errorCode {
//                default: self.showToast("에러: \(error.localizedDescription)")
//                }
//                return
//            } else if let token = token {
//                UserDefaultsManager.token = token
//                completion()
//            }
//        }
//    }
}
