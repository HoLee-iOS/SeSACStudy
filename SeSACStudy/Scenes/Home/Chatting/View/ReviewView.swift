//
//  ReviewView.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/04.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class ReviewView: BaseView {
    
    let disposeBag = DisposeBag()
    
    let registerButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString.init(TextCase.Chatting.reviewButton.rawValue)
        config.attributedTitle?.font = UIFont(name: Fonts.regular, size: 14)
        button.configuration = config
        button.backgroundColor = GrayScale.gray6
        button.tintColor = GrayScale.gray3
        button.layer.cornerRadius = 8
        return button
    }()
    
    let reviewText: UITextView = {
        let text = UITextView()
        text.backgroundColor = GrayScale.gray1
        text.text = TextCase.Chatting.reviewPlaceholder.rawValue
        text.textColor = GrayScale.gray7
        text.font = UIFont(name: Fonts.regular, size: 14)
        text.layer.cornerRadius = 8
        return text
    }()
    
    let mannerButton = ReviewButton(TextCase.Review.manner.rawValue, type: ReviewCase.manner)
    
    let promiseButton = ReviewButton(TextCase.Review.promise.rawValue, type: ReviewCase.promise)
    
    let responseButton = ReviewButton(TextCase.Review.response.rawValue, type: ReviewCase.response)
    
    let kindButton = ReviewButton(TextCase.Review.kind.rawValue, type: ReviewCase.kind)
    
    let skillButton = ReviewButton(TextCase.Review.skill.rawValue, type: ReviewCase.skill)
    
    let beneficialButton = ReviewButton(TextCase.Review.beneficial.rawValue, type: ReviewCase.beneficial)
    
    lazy var reviewType1: UIStackView = {
        let view = UIStackView(arrangedSubviews: [mannerButton, promiseButton])
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    
    lazy var reviewType2: UIStackView = {
        let view = UIStackView(arrangedSubviews: [responseButton, kindButton])
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    
    lazy var reviewType3: UIStackView = {
        let view = UIStackView(arrangedSubviews: [skillButton, beneficialButton])
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "\(ChatDataModel.shared.otherNick)님과의 스터디는 어떠셨나요?"
        label.textColor = BrandColor.green
        label.font = UIFont(name: Fonts.regular, size: 14)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextCase.Chatting.review.rawValue
        label.textColor = BlackNWhite.black
        label.font = UIFont(name: Fonts.medium, size: 14)
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(Icons.Chat.closeBig, for: .normal)
        return button
    }()
    
    override func configure() {
        backgroundColor = BlackNWhite.white
        layer.cornerRadius = 20
        [registerButton, reviewText, reviewType3, reviewType2, reviewType1, questionLabel, titleLabel, closeButton].forEach{ addSubview($0) }
    }
    
    override func setConstraints() {
        registerButton.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.1)
        }
        
        reviewText.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(registerButton.snp.top).offset(-24)
            $0.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.25)
        }
        
        reviewType3.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(reviewText.snp.top).offset(-24)
            $0.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.08)
        }
        
        reviewType2.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(reviewType3.snp.top).offset(-8)
            $0.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.08)
        }
        
        reviewType1.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(reviewType2.snp.top).offset(-8)
            $0.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.08)
        }
        
        questionLabel.snp.makeConstraints {
            $0.centerX.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(reviewType1.snp.top).offset(-24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(questionLabel.snp.top).offset(-16)
            $0.top.equalTo(safeAreaLayoutGuide).inset(21)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalTo(safeAreaLayoutGuide).inset(21)
            $0.size.equalTo(titleLabel.snp.height)
        }
    }
    
    override func bindData() {
        
        let textObservable = Observable.merge(reviewText.rx.didBeginEditing.map{ TextFieldControl.editingDidBegin }, reviewText.rx.didEndEditing.map{ TextFieldControl.editingDidEnd })
        
        textObservable
            .withUnretained(self)
            .bind { (vc, status) in
                switch status {
                case .editingDidBegin:
                    vc.reviewText.text = vc.reviewText.text == TextCase.Chatting.reviewPlaceholder.rawValue ? nil : vc.reviewText.text
                    vc.reviewText.textColor = BlackNWhite.black
                case .editingDidEnd:
                    if vc.reviewText.text == "" {
                        vc.reviewText.text = TextCase.Chatting.reviewPlaceholder.rawValue
                        vc.reviewText.textColor = GrayScale.gray7
                    }
                }
            }
            .disposed(by: disposeBag)
                
        reviewText.rx.text
            .withUnretained(self)
            .bind { (vc, value) in
                if value == TextCase.Chatting.reviewPlaceholder.rawValue || value?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                    vc.registerButton.backgroundColor = GrayScale.gray6
                    vc.registerButton.tintColor = GrayScale.gray3
                } else {
                    vc.registerButton.backgroundColor = BrandColor.green
                    vc.registerButton.tintColor = BlackNWhite.white
                }
                
            }
            .disposed(by: disposeBag)
    }
}
