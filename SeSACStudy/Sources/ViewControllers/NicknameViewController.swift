//
//  NicknameViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/10.
//

import UIKit
import RxSwift
import RxCocoa

class NicknameViewController: BaseViewController {
    
    let nicknameView = NicknameView()
    
    override func loadView() {
        self.view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bindData() {
        nicknameView.nextButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                if vc.nicknameView.nextButton.backgroundColor == GrayScale.gray6 {
                    vc.showToast("닉네임은 1자 이상 10자 이내로 부탁드려요.")
                } else {
                    UserDefaultsManager.nickname = vc.nicknameView.nicknameText.text ?? ""
                    vc.navigationController?.pushViewController(DateViewController(), animated: true)
                }
            }
            .disposed(by: nicknameView.disposeBag)
    }
}
