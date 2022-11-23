//
//  APIService.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/13.
//

import Foundation
import Alamofire

class APIService {
    
    //MARK: - 로그인 API 통신
    static func login(completion: @escaping (UserInfo?, Int?, Error?) -> Void) {
        AF.request(Router.login).responseDecodable(of: UserInfo.self) { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    //MARK: - 회원가입 API 통신
    static func signUp(completion: @escaping (String?, Int?, Error?) -> Void) {
        AF.request(Router.signUp).responseString{ response in
            guard let statusCode = response.response?.statusCode else { return }
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    //MARK: - 내 정보 관리 저장 버튼 클릭 시 API 통신
    static func myPage(completion: @escaping (String?, Int?, Error?) -> Void) {
        AF.request(Router.save).responseString { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    //MARK: - 회원 탈퇴 시 API 통신
    static func withdraw(completion: @escaping (String?, Int?, Error?) -> Void) {
        AF.request(Router.withdraw).responseString { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    //MARK: - Search API 통신
    static func searchAround(completion: @escaping (SearchInfo?, Int?, Error?) -> Void) {
        AF.request(Router.search).responseDecodable(of: SearchInfo.self) { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
}
