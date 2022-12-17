//
//  ShopRouter.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/15.
//

import Foundation

import Alamofire

enum ShopRouter: URLRequestConvertible {
    
    case myInfo
    case item
    case inApp
    
    var baseURL: URL {
        guard let url = URL(string: UserDefaultsManager.baseURL) else { return URL(fileURLWithPath: "") }
        return url
    }
    
    var method: HTTPMethod {
        switch self {
        case .myInfo: return .get
        case .item: return .post
        case .inApp: return .post
        }
    }
    
    var path: String {
        switch self {
        case .myInfo: return UserDefaultsManager.myInfoPath
        case .item: return UserDefaultsManager.itemPath
        case .inApp: return UserDefaultsManager.inAppPath
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .myInfo, .item, .inApp:
            return ["idtoken" : UserDefaultsManager.token, "Content-Type" : UserDefaultsManager.contentType]
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .item:
            return [
                "sesac" : "\(ShopDataModel.shared.sesac)",
                "background" : "\(ShopDataModel.shared.background)"
            ]
        case .inApp:
            return [
                "receipt" : ShopDataModel.shared.receipt,
                "product" : ShopDataModel.shared.product
            ]
        default: return ["":""]
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
