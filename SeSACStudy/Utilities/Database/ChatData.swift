//
//  ChatData.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/05.
//

import Foundation
import RealmSwift

class ChatData: Object {
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    @Persisted var chatId: String
    @Persisted var toChat: String
    @Persisted var fromChat: String
    @Persisted var chatContent: String
    @Persisted var chatDate: String
    
    convenience init(chatId: String, toChat: String, fromChat: String, chatContent: String, chatDate: String) {
        self.init()
        self.chatId = chatId
        self.toChat = toChat
        self.fromChat = fromChat
        self.chatContent = chatContent
        self.chatDate = chatDate
    }
    
}
