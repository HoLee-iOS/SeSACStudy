//
//  CommonViewModel.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/09.
//

import Foundation

protocol CommonViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    
}
