//
//  GenderCollectionViewCell.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/17.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class GenderCollectionViewCell: BaseCollectionViewCell {
    
    let viewModel = MyInfoViewModel()
    
    let disposeBag = DisposeBag()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.medium, size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        label.attributedText = NSMutableAttributedString(string: "내 성별", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()
    
    let maleButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init("남자")
        titleAttr.font = UIFont(name: Fonts.regular, size: 16)
        titleAttr.foregroundColor = BlackNWhite.black
        config.attributedTitle = titleAttr
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
        button.configuration = config
        button.layer.borderColor = GrayScale.gray3.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func configure() {
        [titleLabel, femaleButton, maleButton].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        femaleButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.verticalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.width.equalTo(safeAreaLayoutGuide).multipliedBy(0.15)
        }
        
        maleButton.snp.makeConstraints { make in
            make.trailing.equalTo(femaleButton.snp.leading).offset(-4)
            make.verticalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.width.equalTo(safeAreaLayoutGuide).multipliedBy(0.15)
        }
    }
    
    override func bindData() {
        
        let input = MyInfoViewModel.Input(maleTap: maleButton.rx.tap, femaleTap: femaleButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        //MARK: - 성별 선택에 대한 분기 처리
        output.genderTap
            .withUnretained(self)
            .bind { (vc, tap) in
                switch tap {
                case .maleTap:
                    if vc.femaleButton.backgroundColor == BrandColor.green {
                        vc.femaleButton.backgroundColor = BlackNWhite.white
                        vc.femaleButton.configuration?.attributedTitle?.foregroundColor = BlackNWhite.black
                    }
                    vc.maleButton.backgroundColor = BrandColor.green
                    vc.maleButton.configuration?.attributedTitle?.foregroundColor = BlackNWhite.white
                    UserDefaultsManager.gender = 1
                case .femaleTap:
                    if vc.maleButton.backgroundColor == BrandColor.green {
                        vc.maleButton.backgroundColor = BlackNWhite.white
                        vc.maleButton.configuration?.attributedTitle?.foregroundColor = BlackNWhite.black
                    }
                    vc.femaleButton.backgroundColor = BrandColor.green
                    vc.femaleButton.configuration?.attributedTitle?.foregroundColor = BlackNWhite.white
                    UserDefaultsManager.gender = 0
                }
            }
            .disposed(by: disposeBag)
    }
}
