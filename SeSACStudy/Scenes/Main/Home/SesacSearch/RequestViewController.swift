//
//  RequestViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/29.
//

import UIKit
import SnapKit
import FirebaseAuth
import RxSwift
import RxCocoa

class RequestViewController: BaseViewController {
    
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
        label.textAlignment = .center
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
    
    var pageIndex = 0
    
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
    
    func setAlertView(page: Int) {
        titleLabel.text = pageIndex == 0 ? "스터디를 요청할게요!" : "스터디를 수락할까요?"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        paragraphStyle.alignment = .center
        subLabel.attributedText = page == 0 ?  NSAttributedString(string: "상대방이 요청을 수락하면\n채팅창에서 대화를 나눌 수 있어요", attributes: [.paragraphStyle : paragraphStyle]) : NSAttributedString(string: "요청을 수락하면 채팅창에서 대화를 나눌 수 있어요", attributes: [.paragraphStyle : paragraphStyle])
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
                vc.pageIndex == 0 ? vc.requestOK() : vc.acceptOK()
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - 통신코드
extension RequestViewController {
    
    //MARK: - 스터디 요청하기 통신
    func requestOK() {
        APIService.studyRequest { [weak self] (value, statusCode, error) in
            guard let statusCode = statusCode else { return }
            guard let status = NetworkError(rawValue: statusCode) else { return }
            switch status {
            case .success: self?.dismiss(animated: true) { self?.view.makeToast("스터디 요청을 보냈습니다", position: .bottom) }
            case .alreadySignUp: self?.acceptOK()
            case .invalidNick: self?.view.makeToast("상대방이 스터디 찾기를 그만두었습니다", position: .bottom)
            case .invalidToken: self?.refreshToken1()
            default: self?.showToast("\(statusCode), 기타 에러")
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
                APIService.studyRequest { [weak self] (value, statusCode, error) in
                    guard let statusCode = statusCode else { return }
                    guard let status = NetworkError(rawValue: statusCode) else { return }
                    switch status {
                    case .success: self?.dismiss(animated: true) { self?.view.makeToast("스터디 요청을 보냈습니다", position: .bottom) }
                    case .alreadySignUp: self?.acceptOK()
                    case .invalidNick: self?.view.makeToast("상대방이 스터디 찾기를 그만두었습니다", position: .bottom)
                    default: self?.showToast("잠시 후 다시 시도해주세요.")
                    }
                }
            }
        }
    }
    
    //MARK: - 스터디 수락하기 통신
    func acceptOK() {
        APIService.studyAccept { [weak self] (value, statusCode, error) in
            guard let statusCode = statusCode else { return }
            guard let status = NetworkError(rawValue: statusCode) else { return }
            switch status {
            case .success: self?.myQueueState()
            case .alreadySignUp: self?.showToast("상대방이 이미 다른 새싹과 스터디를 함께 하는 중입니다")
            case .invalidNick: self?.showToast("상대방이 스터디 찾기를 그만두었습니다")
            case .alreadyMatched:
                self?.view.makeToast("앗! 누군가가 나의 스터디를 수락하였어요!", position: .center, completion: { _ in
                    self?.myQueueState()
                })
            case .invalidToken: self?.refreshToken2()
            default: self?.showToast("잠시 후 다시 시도해주세요.")
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
                APIService.studyAccept { [weak self] (value, statusCode, error) in
                    guard let statusCode = statusCode else { return }
                    guard let status = NetworkError(rawValue: statusCode) else { return }
                    switch status {
                    case .success: self?.myQueueState()
                    case .alreadySignUp: self?.showToast("상대방이 이미 다른 새싹과 스터디를 함께 하는 중입니다")
                    case .invalidNick: self?.showToast("상대방이 스터디 찾기를 그만두었습니다")
                    case .alreadyMatched:
                        self?.view.makeToast("앗! 누군가가 나의 스터디를 수락하였어요!", position: .center, completion: { _ in
                            self?.myQueueState()
                        })
                    default: self?.showToast("잠시 후 다시 시도해주세요.")
                    }
                }
            }
        }
    }
    
    //MARK: - 내 상태 확인 통신
    func myQueueState() {
        APIService.myQueueState { [weak self] (value, statusCode, error) in
            guard let statusCode = statusCode else { return }
            guard let status = NetworkError(rawValue: statusCode) else { return }
            switch status {
            case .success:
                if value?.matched == 1 {
                    self?.dismiss(animated: true, completion: {
                        self?.pageIndex == 0 ? self?.view.makeToast("상대방도 스터디를 요청하여 매칭되었습니다. 잠시 후 채팅방으로 이동합니다", position: .bottom, completion: { _ in
                            self?.navigationController?.pushViewController(ChattingViewController(), animated: true)
                        }) : self?.navigationController?.pushViewController(ChattingViewController(), animated: true)
                    })
                }
            case .invalidToken: self?.refreshToken3()
            default: self?.showToast("\(statusCode), 기타 에러")
            }
        }
    }
    
    //MARK: - 토큰 만료 시 토큰 재발급
    func refreshToken3() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { token, error in
            if let error = error {
                self.showToast("에러: \(error.localizedDescription)")
                return
            } else if let token = token {
                UserDefaultsManager.token = token
                APIService.myQueueState { [weak self] (value, statusCode, error) in
                    guard let statusCode = statusCode else { return }
                    guard let status = NetworkError(rawValue: statusCode) else { return }
                    switch status {
                    case .success:
                        if value?.matched == 1 {
                            self?.dismiss(animated: true, completion: {
                                self?.pageIndex == 0 ? self?.view.makeToast("상대방도 스터디를 요청하여 매칭되었습니다. 잠시 후 채팅방으로 이동합니다", position: .bottom, completion: { _ in
                                    self?.navigationController?.pushViewController(ChattingViewController(), animated: true)
                                }) : self?.navigationController?.pushViewController(ChattingViewController(), animated: true)
                            })
                        }
                    default: self?.showToast("잠시 후 다시 시도해주세요.")
                    }
                }
            }
        }
    }
    
}

