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
        let yearText: ControlProperty<String?>
        let monthText: ControlProperty<String?>
        let dayText: ControlProperty<String?>
    }
    
    struct Output {
        let inputYear: Observable<String>
        let inputMonth: Observable<String>
        let inputDay: Observable<String>
        let validationCheck: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let inputYear = input.pickerDate
            .changed
            .map { value in
                let formmatter = DateFormatter()
                formmatter.dateFormat = "yyyy"
                return formmatter.string(from: value)
            }
            .share()
        
        let inputMonth = input.pickerDate
            .changed
            .map { value in
                let formmatter = DateFormatter()
                formmatter.dateFormat = "MM"
                return formmatter.string(from: value)
            }
            .share()
        
        let inputDay = input.pickerDate
            .changed
            .map { value in
                let formmatter = DateFormatter()
                formmatter.dateFormat = "dd"
                return formmatter.string(from: value)
            }
            .share()
        
        let validationCheck = input.pickerDate
            .changed
            .map { value in
                let inputDate = Calendar.current.dateComponents([.year, .month, .day], from: value)
                let todayDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                if (((todayDate.year ?? 0) - (inputDate.year ?? 0)) >= 17) {
                    if inputDate.month ?? 0 <= todayDate.month ?? 0 {
                        if inputDate.day ?? 0 <= todayDate.day ?? 0 {
                            return true
                        }
                    }
                }
                return false
            }
            .share()
        
        return Output(inputYear: inputYear, inputMonth: inputMonth, inputDay: inputDay, validationCheck: validationCheck)
    }
}
