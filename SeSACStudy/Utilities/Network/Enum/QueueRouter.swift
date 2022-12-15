//
//  QueueRouter.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/13.
//

import Foundation
import Alamofire

enum QueueRouter: URLRequestConvertible {
    
    case review
    
    var baseURL: URL {
        guard let url = URL(string: UserDefaultsManager.baseURL) else { return URL(fileURLWithPath: "") }
        return url
    }
    
    var method: HTTPMethod {
        switch self {
        case .review: return .post
        }
    }
    
    var path: String {
        switch self {
        case .review: return UserDefaultsManager.reviewPath
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .review:
            return ["idtoken" : UserDefaultsManager.token, "Content-Type" : UserDefaultsManager.contentType]
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .review:
            return [
                "otheruid" : ChatDataModel.shared.otherUid,
                "reputation": ChatDataModel.shared.reputation,
                "comment" : ChatDataModel.shared.review
            ]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .review:
            return URLEncoding(arrayEncoding: .noBrackets)
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        //통신의 컨텐트 타입이 form-urlencoded이므로 파라미터의 인코딩을 해당 타입에 맞게 해주고 API통신을 요청
        request = try encoding.encode(request, with: parameters)
        return request
    }
}
