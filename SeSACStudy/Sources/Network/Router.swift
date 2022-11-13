//
//  Router.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/13.
//

import Foundation
import Alamofire

struct Login: Codable {
    let token: String
}

//URL컨버터블로 API통신
enum Router: URLRequestConvertible {
    
    case login(verificationCode: String)
    
    var baseURL: URL {
        return URL(string: "http://api.sesac.co.kr:1207/")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .login: return .get
        }
    }
    
    var path: String {
        switch self {
        case .login: return "v1/user"
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .login:
            return ["idtoken" : UserDefaults.standard.string(forKey: "token") ?? "", "Content-Type" : "application/x-www-form-urlencoded"]
        }
    }
    
    var parameters: [String : String] {
        switch self {
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
