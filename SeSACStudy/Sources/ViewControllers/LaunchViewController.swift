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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.startVC()
        }
    }

    func startVC() {
        var vc: UIViewController
        if UserDefaultsManager.first {
            vc = PhoneAuthViewController()
        } else {
            vc = OnBoardingViewController()
        }
        let navigationVC = UINavigationController(rootViewController: vc)
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        guard let delegate = sceneDelegate else { return }
        delegate.window?.rootViewController = navigationVC
    }
}
