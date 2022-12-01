//
//  SesacList.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/28.
//

import Foundation

struct SesacList: Hashable {
    static var aroundList: [FromQueueDB] = []
    static var requestList: [FromQueueDB] = []
    static var recommendList: [String] = []
}
