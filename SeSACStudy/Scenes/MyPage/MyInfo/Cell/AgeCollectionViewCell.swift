//
//  AgeCollectionViewCell.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/17.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AgeCollectionViewCell: BaseCollectionViewCell {
    
    let viewModel = MyInfoViewModel()
    
    let disposeBag = DisposeBag()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.medium, size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        label.attributedText = NSMutableAttributedString(string: "상대방 연령대", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()
    
    lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.textColor = BrandColor.green
        label.font = UIFont(name: Fonts.medium, size: 14)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        label.textAlignment = .right
        label.attributedText = NSMutableAttributedString(string: "\(Int(multiSlider.lower)) - \(Int(multiSlider.upper))", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()
    
    let multiSlider: CustomSlider = {
        let slider = CustomSlider()
        slider.minValue = 18//18
        slider.maxValue = 65//65
        slider.lower = 18//18
        slider.upper = 65//65
        return slider
    }()
    
    override func configure() {
        [multiSlider, titleLabel, ageLabel].forEach{ contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        multiSlider.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(28)
            $0.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.1)
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(multiSlider.snp.top).offset(-16)
            $0.leading.top.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        ageLabel.snp.makeConstraints {
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.bottom.equalTo(multiSlider.snp.top).offset(-16)
        }
    }
    
    override func bindData() {
        
        //MARK: - 유저 디폴트 값을 multiSlider에 적용
        ageLabel.text = "\(UserDefaultsManager.ageMin) - \(UserDefaultsManager.ageMax)"
        multiSlider.lower = Double(UserDefaultsManager.ageMin)
        multiSlider.upper = Double(UserDefaultsManager.ageMax)
        
        
        multiSlider.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .bind { (vc, _) in
                UserDefaultsManager.ageMin = Int(vc.multiSlider.lower)
                UserDefaultsManager.ageMax = Int(vc.multiSlider.upper)
                vc.ageLabel.text = "\(Int(vc.multiSlider.lower)) - \(Int(vc.multiSlider.upper))"
            }
            .disposed(by: disposeBag)
    }
}
