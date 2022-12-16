//
//  ShopView.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/13.
//

import UIKit

import RxSwift
import RxCocoa
import FirebaseAuth
import Toast

class MySesacImageView: BaseView {
    
    let disposeBag = DisposeBag()
    
    lazy var cardBackground: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()
    
    lazy var cardHeader: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 8
        return image
    }()
    
    let requestButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        button.layer.cornerRadius = 8
        config.contentInsets = .init(top: 9, leading: 14, bottom: 9, trailing: 14)
        config.title = TextCase.Shop.save.rawValue
        config.background.backgroundColor = BrandColor.green
        config.baseForegroundColor = BlackNWhite.white
        button.configuration = config
        return button
    }()
    
    override func configure() {
        [cardBackground, cardHeader, requestButton].forEach{ addSubview($0) }
    }
    
    override func setConstraints() {
        cardBackground.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        cardHeader.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(safeAreaLayoutGuide)
            $0.centerY.equalTo(safeAreaLayoutGuide).multipliedBy(1.1)
        }
        
        requestButton.snp.makeConstraints {
            $0.top.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(cardHeader.safeAreaLayoutGuide).multipliedBy(0.15)
            $0.width.equalTo(requestButton.snp.height).multipliedBy(2)
        }
    }
    
    @objc func dataSend() {
        cardBackground.image = SesacBackground(rawValue: ShopDataModel.shared.background)?.image
        cardHeader.image = SesacFace(rawValue: ShopDataModel.shared.sesac)?.image
    }
    
    override func bindData() {
        NotificationCenter.default.addObserver(self, selector: #selector(dataSend), name: Notification.Name("data"), object: nil)
        
        requestButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.updateItem()
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - 새싹과 배경 이미지 업데이트
    func updateItem() {
        APIService.updateItem { [weak self] (value, statusCode, error) in
            guard let statusCode = statusCode else { return }
            guard let status = NetworkError(rawValue: statusCode) else { return }
            switch status {
            case .success: self?.makeToast("성공적으로 저장되었습니다")
            case .alreadySignUp: self?.makeToast("구매가 필요한 아이템이 있어요")
            case .invalidToken: self?.refreshToken()
            default: self?.makeToast("잠시 후 다시 시도해 주세요.")
            }
        }
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
                APIService.updateItem { [weak self] (value, statusCode, error) in
                    guard let statusCode = statusCode else { return }
                    guard let status = NetworkError(rawValue: statusCode) else { return }
                    switch status {
                    case .success: self?.makeToast("성공적으로 저장되었습니다")
                    case .alreadySignUp: self?.makeToast("구매가 필요한 아이템이 있어요")
                    default: self?.makeToast("잠시 후 다시 시도해 주세요.")
                    }
                }
            }
        }
    }
}
