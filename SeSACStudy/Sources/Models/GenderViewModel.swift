//
//  GenderViewModel.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/11.
//

import Foundation
import RxSwift
import RxCocoa

final class GenderViewModel: CommonViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let maleTap: ControlEvent<Void>
        let femaleTap: ControlEvent<Void>
    }
    
    struct Output {
        let genderTap: Observable<GenderTap>
    }
    
    func transform(input: Input) -> Output {
        
        let genderTap = Observable.merge(input.maleTap.map{GenderTap.maleTap}, input.femaleTap.map{GenderTap.femaleTap})
        
        return Output(genderTap: genderTap)
    }
    
}
