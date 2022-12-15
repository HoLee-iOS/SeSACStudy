//
//  PhoneInputViewModel.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/10.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneInputViewModel: CommonViewModel {
    
    struct Input {
        let authNumberText: ControlProperty<String?>
        let editingStatus1: ControlEvent<Void>
        let editingStatus2: ControlEvent<Void>
    }
    
    struct Output {
        let authNum: Observable<Bool>
        let changeFormat: Driver<String>
        let editStatus: Observable<TextFieldControl>
    }
    
    func transform(input: Input) -> Output {
        let validationCheck = input.authNumberText.orEmpty
            .map { str in
                return str.count >= 6
            }
        
        let changeFormatted = input.authNumberText.orEmpty
            .map { str in
                return str
            }
            .asDriver(onErrorJustReturn: "")
        
        let textFieldControl = Observable.merge(input.editingStatus1.map{TextFieldControl.editingDidBegin}, input.editingStatus2.map{TextFieldControl.editingDidEnd})
        
        return Output(authNum: validationCheck, changeFormat: changeFormatted, editStatus: textFieldControl)
    }
    
    
}
