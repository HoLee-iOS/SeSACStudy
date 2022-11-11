//
//  EmailView.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class EmailView: BaseView {
    
    let disposeBag = DisposeBag()
    
    private let viewModel = EmailViewModel()
    
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        paragraphStyle.alignment = .center
        let attributedText = NSMutableAttributedString(string: "이메일을 입력해 주세요", attributes: [NSAttributedString.Key.font: UIFont(name: Fonts.regular, size: 20)!, NSAttributedString.Key.foregroundColor: BlackNWhite.black, .paragraphStyle: paragraphStyle])
        attributedText.append(NSMutableAttributedString(string: "\n\n휴대폰 번호 변경 시 인증을 위해 사용해요", attributes: [NSAttributedString.Key.font: UIFont(name: Fonts.regular, size: 16)!, NSAttributedString.Key.foregroundColor: GrayScale.gray7, .paragraphStyle: paragraphStyle]))
        label.attributedText = attributedText
        return label
    }()
    
    let emailText: UITextField = {
        let text = UITextField()
        text.placeholder = "SeSAC@gmail.com"
        text.font = UIFont(name: Fonts.regular, size: 14)
        return text
    }()
    
    let underline: UIView = {
        let view = UIView()
        view.backgroundColor = GrayScale.gray3
        return view
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = GrayScale.gray6
        return button
    }()
    
    override func configure() {
        [nextButton, underline, emailText, label].forEach { self.addSubview($0) }
    }

    override func setConstraints() {
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.6)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.07)
        }
        
        underline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(nextButton.snp.top).multipliedBy(0.8)
        }
        
        emailText.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(28)
            make.bottom.equalTo(underline.snp.top).offset(15)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.1)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(emailText.snp.top).multipliedBy(0.7)
        }
    }

    override func bindData() {
        
    }
}
