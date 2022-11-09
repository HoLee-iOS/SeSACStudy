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
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let phoneNumberText: ControlProperty<String?>
//        let editingStatus: ControlEvent<()>
    }
    
    struct Output {
        let phoneNum: Observable<Bool>
        let changeFormat: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let validationCheck = input.phoneNumberText.orEmpty
            .map { str in
                let phoneNumRegEx = "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"
                let emailTest = NSPredicate(format:"SELF MATCHES %@", phoneNumRegEx)
                return emailTest.evaluate(with: str)
            }
            .share()
        
        let changeFormatted = input.phoneNumberText.orEmpty
            .map { str in
                str.addHypen()
            }
            .asDriver(onErrorJustReturn: "")
        
//        let editStatus = input.editingStatus
        
        return Output(phoneNum: validationCheck, changeFormat: changeFormatted)
    }
}
