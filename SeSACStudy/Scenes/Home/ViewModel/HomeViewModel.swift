//
//  HomeViewModel.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/22.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: CommonViewModel {
    
    struct Input {
        let allTap: ControlEvent<Void>
        let maleTap: ControlEvent<Void>
        let femaleTap: ControlEvent<Void>
    }
    
    struct Output {
        let filterTap: Observable<GenderFilterTap>
    }
    
    func transform(input: Input) -> Output {
        
        let filterTap = Observable.merge(input.allTap.map{GenderFilterTap.all}, input.maleTap.map{GenderFilterTap.male}, input.femaleTap.map{GenderFilterTap.female})
        
        return Output(filterTap: filterTap)
    }
}
