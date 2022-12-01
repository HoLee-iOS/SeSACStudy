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
    case withdraw
    case search
    case myState
    case request
    case accept
    case stop
    
    var baseURL: URL {
        guard let url = URL(string: UserDefaultsManager.baseURL) else { return URL(fileURLWithPath: "") }
        return url
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .myState: return .get
        case .signUp, .withdraw, .search, .request, .accept: return .post
        case .save: return .put
        case .stop: return .delete
        }
    }
    
    var path: String {
        switch self {
        case .login, .signUp: return UserDefaultsManager.loginPath
        case .save: return UserDefaultsManager.savePath
        case .withdraw: return UserDefaultsManager.withdrawPath
        case .search: return UserDefaultsManager.searchPath
        case .myState: return UserDefaultsManager.myStatePath
        case .request: return UserDefaultsManager.requestPath
        case .accept: return UserDefaultsManager.acceptPath
        case .stop: return UserDefaultsManager.sesacPath
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .login, .signUp, .save, .withdraw, .search, .myState, .request, .accept, .stop:
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
        case .search:
            return [
                "lat" : "\(UserDefaultsManager.lat)",
                "long" : "\(UserDefaultsManager.long)"
            ]
        case .request, .accept:
            return [
                "otheruid" : UserDefaultsManager.otheruid
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
