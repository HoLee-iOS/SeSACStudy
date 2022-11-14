//
//  PhoneInputView.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import FirebaseAuth

final class PhoneInputView: BaseView {
    
    let disposeBag = DisposeBag()
    
    private let viewModel = PhoneInputViewModel()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = BlackNWhite.black
        label.font = UIFont(name: Fonts.regular, size: 20)
        label.numberOfLines = 0
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        paragraphStyle.alignment = .center
        label.attributedText = NSMutableAttributedString(string: "인증번호가 문자로 전송되었어요", attributes: [NSAttributedString.Key.kern: -0.5, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()
    
    let authNumberText: UITextField = {
        let text = UITextField()
        text.placeholder = "인증번호 입력"
        text.font = UIFont(name: Fonts.regular, size: 14)
        text.keyboardType = .numberPad
        return text
    }()
    
    let limitSeconds: UILabel = {
        let label = UILabel()
        label.textColor = BrandColor.green
        label.font = UIFont(name: Fonts.medium, size: 14)
        label.numberOfLines = 0
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        paragraphStyle.alignment = .right
        label.attributedText = NSMutableAttributedString(string: "05:00", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()
    
    let resendButton: UIButton = {
        let button = UIButton()
        button.setTitle("재전송", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = BrandColor.green
        return button
    }()
    
    let underline: UIView = {
        let view = UIView()
        view.backgroundColor = GrayScale.gray6
        return view
    }()
    
    let authButton: UIButton = {
        let button = UIButton()
        button.setTitle("인증하고 시작하기", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = GrayScale.gray6
        return button
    }()
    
    override func configure() {
        [authButton, underline, resendButton, limitSeconds, authNumberText, label].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        authButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.6)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.07)
        }
        
        resendButton.snp.makeConstraints { make in
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.055)
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.2)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(authButton.snp.top).multipliedBy(0.8)
        }
        
        underline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(resendButton.snp.leading).offset(-8)
            make.bottom.equalTo(authButton.snp.top).multipliedBy(0.8)
        }
        
        limitSeconds.snp.makeConstraints { make in
            make.bottom.equalTo(underline.snp.top).offset(15)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.1)
            make.trailing.equalTo(resendButton.snp.leading).multipliedBy(0.95)
        }
        
        authNumberText.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(28)
            make.bottom.equalTo(underline.snp.top).offset(15)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.1)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(authNumberText.snp.top).multipliedBy(0.7)
        }
    }
    
    override func bindData() {
        
        let input = PhoneInputViewModel.Input(authNumberText: authNumberText.rx.text, editingStatus1: authNumberText.rx.controlEvent(.editingDidBegin), editingStatus2: authNumberText.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit]))
        let output = viewModel.transform(input: input)
        
        //MARK: - 편집 상태에 따른 Underline 색상 변경
        output.editStatus
            .withUnretained(self)
            .bind { (vc, actions) in
                switch actions {
                case .editingDidBegin: vc.underline.backgroundColor = BlackNWhite.black
                case .editingDidEnd: vc.underline.backgroundColor = GrayScale.gray6
                }
            }
            .disposed(by: disposeBag)
        
        //MARK: - 인증 번호에 대한 유효성 검사
        output.authNum
            .withUnretained(self)
            .bind { (vc, value) in
                value ? (vc.authButton.backgroundColor = BrandColor.green) : (vc.authButton.backgroundColor = GrayScale.gray6)
            }
            .disposed(by: disposeBag)
        
        //MARK: - 텍스트필드 글자 수 제한
        output.changeFormat
            .drive { [weak self] str in
                self?.limitCount(str)
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - 글자 제한 메서드
    private func limitCount(_ str: String) {
        if str.count > 6 {
            let index = str.index(str.startIndex, offsetBy: 6)
            self.authNumberText.text = String(str[..<index])
        }
    }
}
