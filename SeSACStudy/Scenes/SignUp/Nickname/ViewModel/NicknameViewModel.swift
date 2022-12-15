//
//  NicknameViewModel.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/10.
//

import Foundation
import RxSwift
import RxCocoa

final class NicknameViewModel: CommonViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let nicknameText: ControlProperty<String?>
        let editingStatus1: ControlEvent<Void>
        let editingStatus2: ControlEvent<Void>
    }
    
    struct Output {
        let nickName: Observable<Bool>
        let changeFormat: Driver<String>
        let editStatus: Observable<TextFieldControl>
    }
    
    func transform(input: Input) -> Output {
        let validationCheck = input.nicknameText.orEmpty
            .map { str in
                return str.count >= 1 && str.count <= 10
            }
        
        let changeFormatted = input.nicknameText.orEmpty
            .map { str in
                return str
            }
            .asDriver(onErrorJustReturn: "")
        
        let editStatus = Observable.merge(input.editingStatus1.map{TextFieldControl.editingDidBegin}, input.editingStatus2.map{TextFieldControl.editingDidEnd})
        
        return Output(nickName: validationCheck, changeFormat: changeFormatted, editStatus: editStatus)
    }
    
}
