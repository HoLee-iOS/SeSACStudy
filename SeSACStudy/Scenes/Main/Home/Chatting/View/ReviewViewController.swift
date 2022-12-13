//
//  ReviewViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/04.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class ReviewViewController: BaseViewController {
    
    let popup = ReviewView()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        view.backgroundColor = BlackNWhite.black.withAlphaComponent(0.5)
        view.addSubview(popup)
    }
    
    override func setConstraints() {
        popup.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
            $0.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func bindData() {
        popup.closeButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        popup.registerButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                let viewController = CancelViewController()
                viewController.type = vc.popup.registerButton.currentTitle ?? ""
                viewController.modalPresentationStyle = .overFullScreen
                vc.present(viewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

