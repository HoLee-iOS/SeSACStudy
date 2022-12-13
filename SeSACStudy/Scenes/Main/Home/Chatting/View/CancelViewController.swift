//
//  CancelViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/13.
//

import UIKit

import RxSwift
import RxCocoa
import FirebaseAuth
import SnapKit

class CancelViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    var type = ""
    
    let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = BlackNWhite.white
        view.layer.cornerRadius = 16
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = BlackNWhite.black
        label.font = UIFont(name: Fonts.medium, size: 16)
        label.textAlignment = .center
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = GrayScale.gray7
        label.font = UIFont(name: Fonts.regular, size: 14)
        return label
    }()
    
    let cancelButton: UIButton = {
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init("취소")
        titleAttr.foregroundColor = BlackNWhite.black
        titleAttr.font = UIFont(name: Fonts.regular, size: 14)
        config.attributedTitle = titleAttr
        config.titleAlignment = .center
        config.background.cornerRadius = 8
        config.background.backgroundColor = GrayScale.gray2
        let button = UIButton(configuration: config)
        return button
    }()
    
    let okButton: UIButton = {
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init("확인")
        titleAttr.foregroundColor = BlackNWhite.white
        titleAttr.font = UIFont(name: Fonts.regular, size: 14)
        config.attributedTitle = titleAttr
        config.titleAlignment = .center
        config.background.cornerRadius = 8
        config.background.backgroundColor = BrandColor.green
        let button = UIButton(configuration: config)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = BlackNWhite.black.withAlphaComponent(0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch CancelCase(rawValue: type) {
        case .cancel:
            titleLabel.text = CancelCase.cancelContent.title.rawValue
            subLabel.text = CancelCase.cancelContent.description.rawValue
        case .quit:
            titleLabel.text = CancelCase.quitContent.title.rawValue
            subLabel.text = CancelCase.quitContent.description.rawValue
        case .review:
            titleLabel.text = ChatDataModel.shared.otherNick + CancelCase.reviewContent.title.rawValue
            subLabel.text = CancelCase.reviewContent.description.rawValue
        default: break
        }
    }
    
    override func configure() {
        view.addSubview(alertView)
        
        [titleLabel, subLabel, cancelButton, okButton].forEach{ alertView.addSubview($0) }
    }
    
    override func setConstraints() {
        alertView.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.23)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(alertView)
            $0.top.equalTo(alertView.snp.top).inset(8)
            $0.height.equalTo(alertView).multipliedBy(0.25)
        }
        
        subLabel.snp.makeConstraints {
            $0.centerX.equalTo(alertView)
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.height.equalTo(alertView).multipliedBy(0.25)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(16)
            $0.leading.bottom.equalTo(alertView).inset(16)
            $0.trailing.equalTo(alertView.snp.centerX).offset(-4)
        }
        
        okButton.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(16)
            $0.trailing.bottom.equalTo(alertView).inset(16)
            $0.leading.equalTo(alertView.snp.centerX).offset(4)
        }
    }
    
    override func bindData() {
        cancelButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        okButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                switch CancelCase(rawValue: vc.type) {
                case .review: vc.writeReview()
                default: vc.studyCancel()
                }
            }
            .disposed(by: disposeBag)
    }
}

extension CancelViewController {
    
    //MARK: - 스터디 취소
    func studyCancel() {
        APIService.studyCancel { [weak self] (value, statusCode, error) in
            guard let statusCode = statusCode else { return }
            guard let status = NetworkError(rawValue: statusCode) else { return }
            switch status {
            case .success:
                self?.dismiss(animated: true) {
                    self?.setRootVC(vc: MainTabBarController())
                }
            case .invalidToken: self?.refreshToken1()
            default: self?.showToast("\(statusCode) 에러")
            }
        }
    }
    
    //MARK: - 토큰 만료 시 토큰 재발급
    func refreshToken1() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { token, error in
            if let error = error {
                self.showToast("에러: \(error.localizedDescription)")
                return
            } else if let token = token {
                UserDefaultsManager.token = token
                APIService.studyCancel { [weak self] (value, statusCode, error) in
                    guard let statusCode = statusCode else { return }
                    guard let status = NetworkError(rawValue: statusCode) else { return }
                    switch status {
                    case .success:
                        self?.dismiss(animated: true) {
                            self?.setRootVC(vc: MainTabBarController())
                        }
                    default: self?.showToast("잠시 후 다시 시도해주세요.")
                    }
                }
            }
        }
    }
    
    //MARK: - 리뷰 작성
    func writeReview() {
        APIService.studyReview { [weak self] (value, statusCode, error) in
            guard let statusCode = statusCode else { return }
            guard let status = NetworkError(rawValue: statusCode) else { return }
            switch status {
            case .success:
                self?.dismiss(animated: true) {
                    self?.setRootVC(vc: MainTabBarController())
                }
            case .invalidToken: self?.refreshToken2()
            default: self?.showToast("\(statusCode) 에러")
            }
        }
    }
    
    //MARK: - 토큰 만료 시 토큰 재발급
    func refreshToken2() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { token, error in
            if let error = error {
                self.showToast("에러: \(error.localizedDescription)")
                return
            } else if let token = token {
                UserDefaultsManager.token = token
                APIService.studyReview { [weak self] (value, statusCode, error) in
                    guard let statusCode = statusCode else { return }
                    guard let status = NetworkError(rawValue: statusCode) else { return }
                    switch status {
                    case .success:
                        self?.dismiss(animated: true) {
                            self?.setRootVC(vc: MainTabBarController())
                        }
                    default: self?.showToast("잠시 후 다시 시도해주세요.")
                    }
                }
            }
        }
    }
}
