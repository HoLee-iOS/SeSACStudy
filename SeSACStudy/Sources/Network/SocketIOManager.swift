//
//  SocketIOManager.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/06.
//

import Foundation
import SocketIO

class SocketIOManager {
    
    static let shared = SocketIOManager()
    
    //서버와 메시지를 주고 받기 위한 클래스
    var manager: SocketManager!
    
    var socket: SocketIOClient!
    
    private init() {
        
        //URL 설정
        manager = SocketManager(socketURL: URL(string: UserDefaultsManager.baseURL)!, config: [
            .forceWebsockets(true)
        ])
        
        //세부 링크 설정
        socket = manager.defaultSocket // http://api.sesac.co.kr:2022/
        
        //연결
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED", data, ack)
            self.socket.emit("changesocketid", ChatDataModel.shared.myUid)
        }
        
        //연결 해제
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
        
        //이벤트 수신
        socket.on(TextCase.Chatting.ChatSokcet.chat.rawValue) { dataArray, ack in
            print("CHAT RECEIVED", dataArray, ack)
            
            //인코딩되어있는 내용을 타입캐스팅을 통해 알아볼 수 있게 변환함
            let data = dataArray[0] as! NSDictionary
            let id = data[TextCase.Chatting.ChatSokcet.id.rawValue] as! String
            let chat = data[TextCase.Chatting.ChatSokcet.chat.rawValue] as! String
            let createdAt = data[TextCase.Chatting.ChatSokcet.createdAt.rawValue] as! String
            let from = data[TextCase.Chatting.ChatSokcet.from.rawValue] as! String
            let to = data[TextCase.Chatting.ChatSokcet.to.rawValue] as! String
            
            print("Check >>>", id, chat, createdAt, from, to)
            
            NotificationCenter.default.post(name: NSNotification.Name("getMessage"), object: self, userInfo: [TextCase.Chatting.ChatSokcet.id.rawValue: id, TextCase.Chatting.ChatSokcet.chat.rawValue: chat, TextCase.Chatting.ChatSokcet.createdAt.rawValue: createdAt, TextCase.Chatting.ChatSokcet.from.rawValue: from, TextCase.Chatting.ChatSokcet.to.rawValue: to])
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
}
