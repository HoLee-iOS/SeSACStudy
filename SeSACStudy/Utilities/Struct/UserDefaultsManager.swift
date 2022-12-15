//
//  UserDefaultsManager.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/14.
//

import Foundation

struct UserDefaultsManager {
    
    @UserDefaultsWrapper(key: "token", defaultValue: "")
    static var token: String
    
    @UserDefaultsWrapper(key: "baseURL", defaultValue: "http://api.sesac.co.kr:1210")
    static var baseURL: String
    
    @UserDefaultsWrapper(key: "contentType", defaultValue: "application/x-www-form-urlencoded")
    static var contentType: String
    
    @UserDefaultsWrapper(key: "loginPath", defaultValue: "/v1/user")
    static var loginPath: String
    
    @UserDefaultsWrapper(key: "savePath", defaultValue: "/v1/user/mypage")
    static var savePath: String
    
    @UserDefaultsWrapper(key: "withdrawPath", defaultValue: "/v1/user/withdraw")
    static var withdrawPath: String
    
    @UserDefaultsWrapper(key: "searchPath", defaultValue: "/v1/queue/search")
    static var searchPath: String
    
    @UserDefaultsWrapper(key: "myStatePath", defaultValue: "/v1/queue/myQueueState")
    static var myStatePath: String
    
    @UserDefaultsWrapper(key: "requestPath", defaultValue: "/v1/queue/studyrequest")
    static var requestPath: String
    
    @UserDefaultsWrapper(key: "acceptPath", defaultValue: "/v1/queue/studyaccept")
    static var acceptPath: String
    
    @UserDefaultsWrapper(key: "sesacPath", defaultValue: "/v1/queue")
    static var sesacPath: String
    
    @UserDefaultsWrapper(key: "sendPath", defaultValue: "/v1/chat/\(ChatDataModel.shared.otherUid)")
    static var sendPath: String
    
    @UserDefaultsWrapper(key: "listPath", defaultValue: "/v1/chat/\(ChatDataModel.shared.otherUid)")
    static var listPath: String
    
    @UserDefaultsWrapper(key: "dodgePath", defaultValue: "/v1/queue/dodge")
    static var dodgePath: String
    
    @UserDefaultsWrapper(key: "reviewPath", defaultValue: "/v1/queue/rate/\(ChatDataModel.shared.otherUid)")
    static var reviewPath: String
    
    @UserDefaultsWrapper(key: "myInfoPath", defaultValue: "/v1/user/shop/myinfo")
    static var myInfoPath: String
    
    @UserDefaultsWrapper(key: "itemPath", defaultValue: "/v1/user/shop/item")
    static var itemPath: String
    
    @UserDefaultsWrapper(key: "inAppPath", defaultValue: "/v1/user/shop/ios")
    static var inAppPath: String
    
    @UserDefaultsWrapper(key: "otheruid", defaultValue: "")
    static var otheruid: String
    
    @UserDefaultsWrapper(key: "verificationCode", defaultValue: "")
    static var verificationCode: String
    
    @UserDefaultsWrapper(key: "phoneNum", defaultValue: "")
    static var phoneNum: String
    
    @UserDefaultsWrapper(key: "verificationID", defaultValue: "")
    static var verificationID: String
    
    @UserDefaultsWrapper(key: "birth", defaultValue: "")
    static var birth: String
    
    @UserDefaultsWrapper(key: "email", defaultValue: "")
    static var email: String
    
    @UserDefaultsWrapper(key: "gender", defaultValue: 2)
    static var gender: Int
    
    @UserDefaultsWrapper(key: "nickname", defaultValue: "")
    static var nickname: String
    
    @UserDefaultsWrapper(key: "first", defaultValue: false)
    static var first: Bool
    
    @UserDefaultsWrapper(key: "fcmToken", defaultValue: "")
    static var fcmToken: String
    
    @UserDefaultsWrapper(key: "searchable", defaultValue: 0)
    static var searchable: Int
    
    @UserDefaultsWrapper(key: "ageMin", defaultValue: 18)
    static var ageMin: Int
    
    @UserDefaultsWrapper(key: "ageMax", defaultValue: 65)
    static var ageMax: Int
    
    @UserDefaultsWrapper(key: "study", defaultValue: "")
    static var study: String?
    
    @UserDefaultsWrapper(key: "lat", defaultValue: 0)
    static var lat: Double
    
    @UserDefaultsWrapper(key: "long", defaultValue: 0)
    static var long: Double
    
    @UserDefaultsWrapper(key: "studyList", defaultValue: ["anything"])
    static var studyList: Array
    
    @UserDefaultsWrapper(key: "matched", defaultValue: 0)
    static var matched: Int
    
    static func resetData() {
        UserDefaultsManager.token = ""
        UserDefaultsManager.phoneNum = ""
        UserDefaultsManager.birth = ""
        UserDefaultsManager.email = ""
        UserDefaultsManager.gender = 2
        UserDefaultsManager.nickname = ""
        UserDefaultsManager.first = false
        UserDefaultsManager.fcmToken = ""
        UserDefaultsManager.searchable = 0
        UserDefaultsManager.ageMin = 18
        UserDefaultsManager.ageMax = 65
        UserDefaultsManager.study = ""
    }
}
