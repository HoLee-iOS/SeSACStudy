//
//  ChatViewModel.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/04.
//

import Foundation

import RxSwift
import RxCocoa

class ChatViewModel: CommonViewModel {
    
    struct Input {
        let editingBegin: ControlEvent<()>
        let editingEnd: ControlEvent<()>
    }
    
    struct Output {
        let chatPlaceholder: Observable<TextFieldControl>
    }
    
    func transform(input: Input) -> Output {
        
        let placeholder = Observable.merge(input.editingBegin.map{ TextFieldControl.editingDidBegin }, input.editingEnd.map{ TextFieldControl.editingDidEnd })
        
        return Output(chatPlaceholder: placeholder)
    }    
}
