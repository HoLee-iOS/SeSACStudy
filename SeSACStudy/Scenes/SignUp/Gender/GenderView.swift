//
//  GenderView.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class GenderView: BaseView {
    
    let disposeBag = DisposeBag()
    
    private let viewModel = GenderViewModel()
    
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        paragraphStyle.alignment = .center
        let attributedText = NSMutableAttributedString(string: "성별을 선택해 주세요", attributes: [NSAttributedString.Key.font: UIFont(name: Fonts.regular, size: 20)!, NSAttributedString.Key.foregroundColor: BlackNWhite.black, .paragraphStyle: paragraphStyle])
        attributedText.append(NSMutableAttributedString(string: "\n\n새싹 찾기 기능을 이용하기 위해서 필요해요!", attributes: [NSAttributedString.Key.font: UIFont(name: Fonts.regular, size: 16)!, NSAttributedString.Key.foregroundColor: GrayScale.gray7, .paragraphStyle: paragraphStyle]))
        label.attributedText = attributedText
        return label
    }()
    
    let maleButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init("남자")
        titleAttr.font = UIFont(name: Fonts.regular, size: 16)
        titleAttr.foregroundColor = BlackNWhite.black
        config.attributedTitle = titleAttr
        config.image = Icons.male
        config.imagePlacement = .top
        button.configuration = config
        button.layer.borderColor = GrayScale.gray3.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        return button
    }()
    
    let femaleButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init("여자")
        titleAttr.font = UIFont(name: Fonts.regular, size: 16)
        titleAttr.foregroundColor = BlackNWhite.black
        config.attributedTitle = titleAttr
        config.image = Icons.female
        config.imagePlacement = .top
        button.configuration = config
        button.layer.borderColor = GrayScale.gray3.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = GrayScale.gray6
        return button
    }()
    
    override func configure() {
        [nextButton, maleButton, femaleButton, label].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.6)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.07)
        }
        
        maleButton.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.bottom.equalTo(nextButton.snp.top).multipliedBy(0.9)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.2)
            make.width.equalTo(self.safeAreaLayoutGuide).dividedBy(2.25)
        }
        
        femaleButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(nextButton.snp.top).multipliedBy(0.9)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.2)
            make.width.equalTo(self.safeAreaLayoutGuide).dividedBy(2.25)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(maleButton.snp.top).multipliedBy(0.9)
        }
    }
    
    override func bindData() {
        
        let input = GenderViewModel.Input(maleTap: maleButton.rx.tap, femaleTap: femaleButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        //MARK: - 성별 선택에 대한 분기 처리
        output.genderTap
            .withUnretained(self)
            .bind { (vc, tap) in
                vc.nextButton.backgroundColor = GrayScale.gray6
                switch tap {
                case .maleTap:
                    if vc.femaleButton.backgroundColor == BrandColor.whiteGreen {
                        vc.femaleButton.backgroundColor = BlackNWhite.white
                    }
                    vc.maleButton.backgroundColor = BrandColor.whiteGreen
                    vc.nextButton.backgroundColor = BrandColor.green
                    UserDefaultsManager.gender = 1
                case .femaleTap:
                    if vc.maleButton.backgroundColor == BrandColor.whiteGreen {
                        vc.maleButton.backgroundColor = BlackNWhite.white
                    }
                    vc.femaleButton.backgroundColor = BrandColor.whiteGreen
                    vc.nextButton.backgroundColor = BrandColor.green
                    UserDefaultsManager.gender = 0
                }
            }
            .disposed(by: disposeBag)
    }
}
