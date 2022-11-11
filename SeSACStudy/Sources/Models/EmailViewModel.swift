//
//  EmailViewModel.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/11.
//

import Foundation
import RxSwift
import RxCocoa

final class EmailViewModel: CommonViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let emailText: ControlProperty<String?>
    }
    
    struct Output {
        let validationCheck: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let validationCheck = input.emailText.orEmpty
            .map { str in
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                return emailTest.evaluate(with: str)
            }
        
        return Output(validationCheck: validationCheck)
    }
    
}
