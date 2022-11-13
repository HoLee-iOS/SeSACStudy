//
//  APIService.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/13.
//

import Foundation
import Alamofire

class APIService {
    
    static func login(idToken: String, completion: @escaping (UserInfo?, Int?, Error?) -> Void) {
        AF.request(Router.login(verificationCode: idToken)).responseDecodable(of: UserInfo.self) { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch response.result {
            case.success(let data):
                completion(data, statusCode, nil)
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
}
