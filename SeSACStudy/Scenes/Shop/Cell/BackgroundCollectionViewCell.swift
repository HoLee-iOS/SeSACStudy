//
//  BackgroundCollectionViewCell.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/15.
//

import UIKit

import FirebaseAuth
import RxSwift
import RxCocoa
import SnapKit

class BackgroundCollectionViewCell: BaseCollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    var index = 0
    
    let sesacBackground: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.regular, size: 16)
        return label
    }()
    
    let priceButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.configuration = config
        return button
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: Fonts.regular, size: 14)
        return label
    }()
    
    let labelView: UIView = {
        let view = UIView()
        view.backgroundColor = BlackNWhite.black
        return view
    }()
    
    override func configure() {
        [sesacBackground, nameLabel, priceButton, descriptionLabel].forEach{ contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        sesacBackground.snp.makeConstraints {
            $0.verticalEdges.leading.equalTo(safeAreaLayoutGuide)
            $0.width.equalTo(sesacBackground.snp.height)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(sesacBackground.snp.trailing).offset(12)
            $0.bottom.equalTo(sesacBackground.snp.centerY).multipliedBy(0.9)
        }
        
        priceButton.snp.makeConstraints {
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(12)
            $0.height.equalTo(nameLabel.snp.height)
            $0.bottom.equalTo(nameLabel.snp.bottom)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(12)
            $0.leading.equalTo(sesacBackground.snp.trailing).offset(12)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(12)
        }
    }
    
    override func bindData() {
        priceButton.rx.tap
            .withUnretained(self)
            .bind { (cell, _) in
                cell.loadMyInfo()
                if cell.priceButton.currentAttributedTitle != NSAttributedString(string: TextCase.Shop.mine.rawValue, attributes: [NSAttributedString.Key.font: UIFont(name: Fonts.medium, size: 12)!]) {
                    cell.inApp()
                }
            }
            .disposed(by: disposeBag)
    }
    
    func inputData(index: Int) {
        if MyDataModel.shared.data.backgroundCollection.contains(index) {
            priceButton.setAttributedTitle(NSAttributedString(string: TextCase.Shop.mine.rawValue, attributes: [NSAttributedString.Key.font: UIFont(name: Fonts.medium, size: 12)!]), for: .normal)
            priceButton.configuration?.baseForegroundColor = GrayScale.gray7
            priceButton.backgroundColor = GrayScale.gray2
        } else {
            priceButton.configuration?.baseForegroundColor = BlackNWhite.white
            priceButton.backgroundColor = BrandColor.green
        }
    }
}

extension BackgroundCollectionViewCell {
    //MARK: - 내 정보 불러오기
    func loadMyInfo() {
        APIService.requestMyInfo { [weak self] (value, statusCode, error) in
            guard let statusCode = statusCode else { return }
            guard let status = NetworkError(rawValue: statusCode) else { return }
            switch status {
            case .success: self?.inputData(index: self?.index ?? 0)
            case .invalidToken: self?.refreshToken1()
            default: self?.makeToast("잠시 후 다시 시도해 주세요.")
            }
        }
    }
    
    //MARK: - 토큰 만료 시 토큰 재발급
    func refreshToken1() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { token, error in
            if let error = error as? NSError {
                guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
                switch errorCode {
                default: self.makeToast("에러: \(error.localizedDescription)")
                }
                return
            } else if let token = token {
                UserDefaultsManager.token = token
                APIService.requestMyInfo { [weak self] (value, statusCode, error) in
                    guard let statusCode = statusCode else { return }
                    guard let status = NetworkError(rawValue: statusCode) else { return }
                    switch status {
                    case .success: self?.inputData(index: self?.index ?? 0)
                    default: self?.makeToast("잠시 후 다시 시도해 주세요.")
                    }
                }
            }
        }
    }
    
    //MARK: - 인앱 결제
    func inApp() {
        APIService.inApp { [weak self] (value, statusCode, error) in
            guard let statusCode = statusCode else { return }
            guard let status = NetworkError(rawValue: statusCode) else { return }
            switch status {
            case .success: print("아이템 구매 성공")
            case .alreadySignUp: print("영수증 검증실패")
            case .invalidToken: self?.refreshToken2()
            default: self?.makeToast("잠시 후 다시 시도해 주세요.")
            }
        }
    }
    
    //MARK: - 토큰 만료 시 토큰 재발급
    func refreshToken2() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { token, error in
            if let error = error as? NSError {
                guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
                switch errorCode {
                default: self.makeToast("에러: \(error.localizedDescription)")
                }
                return
            } else if let token = token {
                UserDefaultsManager.token = token
                APIService.inApp { [weak self] (value, statusCode, error) in
                    guard let statusCode = statusCode else { return }
                    guard let status = NetworkError(rawValue: statusCode) else { return }
                    switch status {
                    case .success: print("아이템 구매 성공")
                    case .alreadySignUp: print("영수증 검증실패")
                    default: self?.makeToast("잠시 후 다시 시도해 주세요.")
                    }
                }
            }
        }
    }
}
