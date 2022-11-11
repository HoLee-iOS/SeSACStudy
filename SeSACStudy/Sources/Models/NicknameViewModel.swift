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
        let editStatus1: Driver<Void>
        let editStatus2: Driver<Void>
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
        
        let editStatus1 = input.editingStatus1
            .asDriver()
        
        let editStatus2 = input.editingStatus2
            .asDriver()
        
        return Output(nickName: validationCheck, changeFormat: changeFormatted, editStatus1: editStatus1, editStatus2: editStatus2)
    }
    
}
