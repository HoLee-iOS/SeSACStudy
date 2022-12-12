//
//  ChatRepository.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/05.
//

import Foundation

import RealmSwift

class ChatRepository {
    
    private init() {}
    
    static let shared = ChatRepository()
    
    let localRealm = try! Realm()
    
    var tasks: Results<ChatData>?
    
    func fetch() {
        tasks = localRealm.objects(ChatData.self)
    }
    
    //MARK: - 채팅 저장 기능
    func sendChat(item: ChatData) {
        do {
            try localRealm.write {
                localRealm.add(item)
            }
        } catch let error {
            print(error)
        }
    }
    
    //MARK: - 채팅 삭제 기능
    func deleteChat(item: ChatData) {
        try! localRealm.write {
            localRealm.deleteAll()
        }
    }
}
