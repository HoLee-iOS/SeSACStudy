//
//  Router.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/13.
//

import Foundation
import Alamofire

//URL컨버터블로 API통신
enum Router: URLRequestConvertible {
    
    case login
    case signUp
    case save
    
    var baseURL: URL {
        guard let url = URL(string: UserDefaultsManager.baseURL) else { return URL(fileURLWithPath: "") }
        return url
    }
    
    var method: HTTPMethod {
        switch self {
        case .login: return .get
        case .signUp: return .post
        case .save: return .put
        }
    }
    
    var path: String {
        switch self {
        case .login, .signUp: return UserDefaultsManager.loginPath
        case .save: return UserDefaultsManager.savePath
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .login, .signUp, .save:
            return ["idtoken" : UserDefaultsManager.token, "Content-Type" : UserDefaultsManager.contentType]
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .signUp:
            return [
                "phoneNumber" : UserDefaultsManager.phoneNum,
                "FCMtoken" : UserDefaultsManager.fcmToken,
                "nick" : UserDefaultsManager.nickname,
                "birth" : UserDefaultsManager.birth,
                "email" : UserDefaultsManager.email,
                "gender" : "\(UserDefaultsManager.gender)"
            ]
        case .save:
            return [
                "searchable" : "\(UserDefaultsManager.searchable)",
                "ageMin" : "\(UserDefaultsManager.ageMin)",
                "ageMax" : "\(UserDefaultsManager.ageMax)",
                "gender" : "\(UserDefaultsManager.gender)",
                "study" : UserDefaultsManager.study ?? ""
            ]
        default:
            return ["":""]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        //통신의 컨텐트 타입이 form-urlencoded이므로 파라미터의 인코딩을 해당 타입에 맞게 해주고 API통신을 요청
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)        
        return request
    }
}
