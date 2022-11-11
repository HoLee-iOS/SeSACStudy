//
//  LaunchViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/12.
//

import UIKit

class LaunchViewController: BaseViewController {
    
    let splash = SplashView()
    
    override func loadView() {
        self.view = splash
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bindData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.startVC()
        }
    }

    func startVC() {
        var vc: UIViewController
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        if UserDefaults.standard.bool(forKey: "First") {
            vc = PhoneAuthViewController()
        } else {
            vc = OnBoardingViewController()
        }
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
