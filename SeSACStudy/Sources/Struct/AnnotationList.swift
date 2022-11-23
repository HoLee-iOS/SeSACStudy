//
//  AnnotationList.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/23.
//

import Foundation

struct AnnotationList {
    let type: Int
    let lat: Double
    let long: Double
    let gender: Int
    
    static var allList: [AnnotationList] = []
    static var femaleList = allList.filter { $0.gender == 0 }
    static var maleList = allList.filter { $0.gender == 1 }
}
