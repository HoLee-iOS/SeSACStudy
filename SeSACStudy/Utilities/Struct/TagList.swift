//
//  TagList.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/24.
//

import Foundation

struct TagList: Hashable {
    
    let text: String
    private let identifier = UUID()
    
    static var allTags: [TagList] = []
    static var redTags: [TagList] = []
    static var grayTags: [TagList] = []
    static var greenTags: [TagList] = []
}
