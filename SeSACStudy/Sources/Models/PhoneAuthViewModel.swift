//
//  PhoneAuthViewModel.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/09.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneAuthViewModel: CommonViewModel {
    
    struct Input {
        let phoneNumberText: ControlProperty<String?>
        let editingStatus1: ControlEvent<Void>
        let editingStatus2: ControlEvent<Void>
    }
    
    struct Output {
        let phoneNum: Observable<Bool>
        let changeFormat: Driver<String>
        let editStatus: Observable<TextFieldControl>
    }
    
    func transform(input: Input) -> Output {
        let validationCheck = input.phoneNumberText.orEmpty
            .map { str in
                let phoneNumRegEx = "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"
                let emailTest = NSPredicate(format:"SELF MATCHES %@", phoneNumRegEx)
                return emailTest.evaluate(with: str)
            }
        
        let changeFormatted = input.phoneNumberText.orEmpty
            .map { str in
                str.addHypen()
            }
            .asDriver(onErrorJustReturn: "")
        
        let editStatus = Observable.merge(input.editingStatus1.map{TextFieldControl.editingDidBegin}, input.editingStatus2.map{TextFieldControl.editingDidEnd})
        
        return Output(phoneNum: validationCheck, changeFormat: changeFormatted, editStatus: editStatus)
    }
}
