//
//  ChatDataModel.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/05.
//

import Foundation

class ChatDataModel {
    
    private init() {}
    
    static let shared = ChatDataModel()
    
    var myUid = ""
    var otherUid = ""
    var otherNick = ""
    var content = ""
    var lastDate = ""
    var reputation = [0,0,0,0,0,0,0,0,0]
}
