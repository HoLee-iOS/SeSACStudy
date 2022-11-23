//
//  StudyInputViewModel.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/23.
//

import Foundation
import RxSwift
import RxCocoa

class StudyInputViewModel: CommonViewModel {
    
    struct Input {
        let upKeyboard: ControlEvent<Void>
        let downKeyboard: ControlEvent<Void>
    }
    
    struct Output {
        let setButton: Observable<TextFieldControl>
    }
    
    func transform(input: Input) -> Output {
        
        let setButton = Observable.merge(input.upKeyboard.map { TextFieldControl.editingDidBegin }, input.downKeyboard.map { TextFieldControl.editingDidEnd } )
        
        return Output(setButton: setButton)
    }
    
}
