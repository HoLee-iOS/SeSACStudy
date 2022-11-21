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
    
    static func removeAll() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
    
    static func resetSingupData() {
        
    }
}
