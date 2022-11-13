//
//  DateViewModel.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/10.
//

import Foundation
import RxSwift
import RxCocoa

final class DateViewModel: CommonViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let pickerDate: ControlProperty<Date>
    }
    
    struct Output {
        let inputValue: Observable<DateComponents>
        let validationCheck: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let inputValue = input.pickerDate
            .changed
            .map { value in
                return Calendar.current.dateComponents([.year, .month, .day], from: value)
            }
        
        let validationCheck = input.pickerDate
            .changed
            .map { value in
                let inputDate = Calendar.current.dateComponents([.year, .month, .day], from: value)
                let todayDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                if (((todayDate.year ?? 0) - (inputDate.year ?? 0)) > 17) {
                    return true
                } else if (((todayDate.year ?? 0) - (inputDate.year ?? 0)) == 17) {
                    if inputDate.month ?? 0 < todayDate.month ?? 0 {
                        return true
                    } else if inputDate.month ?? 0 == todayDate.month ?? 0 {
                        if inputDate.day ?? 0 <= todayDate.day ?? 0 {
                            return true
                        }
                    }
                }
                return false
            }
        
        return Output(inputValue: inputValue, validationCheck: validationCheck)
    }
}
