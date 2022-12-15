//
//  MyData.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/15.
//

import Foundation

class MyDataModel {
    
    private init() {}
    
    static let shared = MyDataModel()
    
    var data = MyInfo(sesac: 0, sesacCollection: [], background: 0, backgroundCollection: [])
}
