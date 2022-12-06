//
//  ChatRouter.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/02.
//

import Foundation
import Alamofire

enum ChatRouter: URLRequestConvertible {
    
    case send
    case list
    
    var baseURL: URL {
        guard let url = URL(string: UserDefaultsManager.baseURL) else { return URL(fileURLWithPath: "") }
        return url
    }
    
    var method: HTTPMethod {
        switch self {
        case .send: return .post
        case .list: return .get
        }
    }
    
    var path: String {
        switch self {
        case .send: return UserDefaultsManager.sendPath
        case .list: return UserDefaultsManager.listPath
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .send, .list:
            return ["idtoken" : UserDefaultsManager.token, "Content-Type" : UserDefaultsManager.contentType]
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .send:
            return ["chat" : ChatDataModel.shared.content]
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
