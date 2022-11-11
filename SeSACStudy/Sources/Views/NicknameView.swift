//
//  NicknameView.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NicknameView: BaseView {
    
    let disposeBag = DisposeBag()
    
    private let viewModel = NicknameViewModel()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = BlackNWhite.black
        label.font = UIFont(name: Fonts.regular, size: 20)
        label.numberOfLines = 0
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        paragraphStyle.alignment = .center
        label.attributedText = NSMutableAttributedString(string: "닉네임을 입력해 주세요", attributes: [NSAttributedString.Key.kern: -0.5, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()
    
    let nicknameText: UITextField = {
        let text = UITextField()
        text.placeholder = "10자 이내로 입력"
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
        [nextButton, underline, nicknameText, label].forEach { self.addSubview($0) }
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
        
        nicknameText.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(28)
            make.bottom.equalTo(underline.snp.top).offset(15)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.1)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(nicknameText.snp.top).multipliedBy(0.7)
        }
    }
    
    override func bindData() {
        
        let input = NicknameViewModel.Input(nicknameText: nicknameText.rx.text, editingStatus1: nicknameText.rx.controlEvent(.editingDidBegin), editingStatus2: nicknameText.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit]))
        let output = viewModel.transform(input: input)
        
        //MARK: - 편집 상태에 따른 Underline 색상 변경
        output.editStatus1
            .drive { [weak self] _ in
                self?.underline.backgroundColor = BlackNWhite.black
            }
            .disposed(by: disposeBag)
        
        output.editStatus2
            .drive { [weak self] _ in
                self?.underline.backgroundColor = GrayScale.gray3
            }
            .disposed(by: disposeBag)
        
        //MARK: - 닉네임에 대한 유효성 검사
        output.nickName
            .withUnretained(self)
            .bind { (vc, value) in
                vc.nextButton.isEnabled = value
                value ? (vc.nextButton.backgroundColor = BrandColor.green) : (vc.nextButton.backgroundColor = GrayScale.gray6)
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
        if str.count > 10 {
            let index = str.index(str.startIndex, offsetBy: 10)
            self.nicknameText.text = String(str[..<index])
        }
    }
}
