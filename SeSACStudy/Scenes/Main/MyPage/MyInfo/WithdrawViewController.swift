//
//  WithdrawViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/21.
//

import UIKit
import SnapKit
import FirebaseAuth
import RxSwift
import RxCocoa

class WithdrawViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
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
        label.text = "정말 탈퇴하시겠습니까?"
        label.textAlignment = .center
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = BlackNWhite.black
        label.font = UIFont(name: Fonts.regular, size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        label.textAlignment = .center
        label.attributedText = NSMutableAttributedString(string: "탈퇴하시면 새싹 스터디를 이용할 수 없어요ㅠ", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
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
                APIService.withdraw { value, statusCode, error in
                    guard let statusCode = statusCode else { return }
                    guard let networkErr = NetworkError(rawValue: statusCode) else { return }
                    switch networkErr {
                    case .success, .needSignUp:
                        //MARK: - 저장되어 있던 유저 디폴트 값 초기화
                        UserDefaultsManager.resetData()
                        vc.view.makeToast("회원 탈퇴되어 초기 화면으로 돌아갑니다.") { _ in
                            vc.setRootNavVC(vc: OnBoardingViewController())
                        }
                    case .invalidToken: vc.refreshToken()
                    default: vc.showToast("잠시 후 다시 시도해 주세요.")
                    }
                }
            }
            .disposed(by: disposeBag)
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
                    case .success:
                        self?.view.makeToast("탈퇴되어서 초기 화면으로 돌아갑니다.") { _ in
                            self?.setRootNavVC(vc: OnBoardingViewController())
                        }
                    default: self?.showToast("잠시 후 다시 시도해 주세요.")
                    }
                }
            }
        }
    }
}
