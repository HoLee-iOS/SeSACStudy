//
//  DateView.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DateView: BaseView {
    
    let disposeBag = DisposeBag()
    
    private let viewModel = DateViewModel()
    
    let picker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ko-KR")
        return picker
    }()
    
    func makeText(placeHolder: String) -> UITextField {
        let text = UITextField()
        text.placeholder = placeHolder
        text.font = UIFont(name: Fonts.regular, size: 14)
        text.inputView = picker
        return text
    }
    
    func makeUnderline() -> UIView {
        let view = UIView()
        view.backgroundColor = GrayScale.gray3
        return view
    }
    
    func makeLabel(labelText: String) -> UILabel {
        let label = UILabel()
        label.text = labelText
        return label
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = BlackNWhite.black
        label.font = UIFont(name: Fonts.regular, size: 20)
        label.numberOfLines = 0
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        paragraphStyle.alignment = .center
        label.attributedText = NSMutableAttributedString(string: "생년월일을 알려주세요", attributes: [NSAttributedString.Key.kern: -0.5, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()
    
    //MARK: - 년도
    lazy var yearText = makeText(placeHolder: "1990")
    lazy var underline1 = makeUnderline()
    lazy var yearLabel = makeLabel(labelText: "년")
    
    //MARK: - 월
    lazy var monthText = makeText(placeHolder: "1")
    lazy var underline2 = makeUnderline()
    lazy var monthLabel = makeLabel(labelText: "월")
    
    //MARK: - 일
    lazy var dayText = makeText(placeHolder: "1")
    lazy var underline3 = makeUnderline()
    lazy var dayLabel = makeLabel(labelText: "일")
    
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = GrayScale.gray6
        return button
    }()
    
    override func configure() {
        [nextButton, underline1, underline3, underline2, yearText, yearLabel, monthText, monthLabel, dayText, dayLabel, label].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.6)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.07)
        }
        
        underline1.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.width.equalTo(self.safeAreaLayoutGuide.snp.width).multipliedBy(0.2)
            make.bottom.equalTo(nextButton.snp.top).multipliedBy(0.8)
        }
        
        underline3.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-35)
            make.width.equalTo(self.safeAreaLayoutGuide.snp.width).multipliedBy(0.2)
            make.bottom.equalTo(nextButton.snp.top).multipliedBy(0.8)
        }
        
        underline2.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(self.safeAreaLayoutGuide.snp.width).multipliedBy(0.2)
            make.bottom.equalTo(nextButton.snp.top).multipliedBy(0.8)
        }
        
        yearText.snp.makeConstraints { make in
            make.leading.equalTo(underline1.snp.leading).offset(10)
            make.bottom.equalTo(underline1.snp.top).offset(15)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.1)
        }
        
        dayText.snp.makeConstraints { make in
            make.leading.equalTo(underline3.snp.leading).offset(10)
            make.bottom.equalTo(underline3.snp.top).offset(15)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.1)
        }
        
        monthText.snp.makeConstraints { make in
            make.leading.equalTo(underline2.snp.leading).offset(10)
            make.bottom.equalTo(underline2.snp.top).offset(15)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.1)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.leading.equalTo(underline1.snp.trailing).offset(10)
            make.bottom.equalTo(underline1.snp.top).offset(15)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.1)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.leading.equalTo(underline3.snp.trailing).offset(10)
            make.bottom.equalTo(underline3.snp.top).offset(15)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.1)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.leading.equalTo(underline2.snp.trailing).offset(10)
            make.bottom.equalTo(underline2.snp.top).offset(15)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.1)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(monthText.snp.top).multipliedBy(0.7)
        }
        
    }
    
    override func bindData() {
        
        let input = DateViewModel.Input(pickerDate: picker.rx.date, yearText: yearText.rx.text, monthText: monthText.rx.text, dayText: dayText.rx.text)
        
        let output = viewModel.transform(input: input)
        
        //MARK: - 데이트 피커로 선택한 값 텍스트필드에 입력
        output.inputYear
            .bind(to: yearText.rx.text)
            .disposed(by: disposeBag)
        
        output.inputMonth
            .bind(to: monthText.rx.text)
            .disposed(by: disposeBag)
        
        output.inputDay
            .bind(to: dayText.rx.text)
            .disposed(by: disposeBag)
        
        //MARK: - 만 17살에 대한 유효성 체크
        output.validationCheck
            .withUnretained(self)
            .bind { (vc, value) in
                value ? (vc.nextButton.backgroundColor = BrandColor.green) : (vc.nextButton.backgroundColor = GrayScale.gray5)
            }
            .disposed(by: disposeBag)
        
    }
}
