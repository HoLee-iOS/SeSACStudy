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
                UserDefaultsManager.nickname = data.nick
                ChatDataModel.shared.myUid = data.uid
                MyDataModel.shared.sesac = data.sesac
                MyDataModel.shared.background = data.background
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
    
    //MARK: - 새싹 찾기 요청
    static func sesacSearch(completion: @escaping (String?, Int?, Error?) -> Void) {
        
        let url = UserDefaultsManager.baseURL + UserDefaultsManager.sesacPath
        
        let header: HTTPHeaders = [
            "idtoken": UserDefaultsManager.token,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let parameter: [String : Any] = [
            "long": UserDefaultsManager.long,
            "lat": UserDefaultsManager.lat,
            "studylist": UserDefaultsManager.studyList.isEmpty ? ["anything"] : UserDefaultsManager.studyList
        ]
        let enc: ParameterEncoding = URLEncoding(arrayEncoding: .noBrackets)
        
        AF.request(url, method: .post, parameters: parameter, encoding: enc, headers: header).responseString { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    //MARK: - 새싹 찾기 중단
    static func sesacStop(completion: @escaping (String?, Int?, Error?) -> Void) {
        AF.request(Router.stop).responseString { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    //MARK: - 사용자의 매칭상태 확인
    static func myQueueState(completion: @escaping (MyState?, Int?, Error?) -> Void) {
        AF.request(Router.myState).responseDecodable(of: MyState.self) { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch response.result {
            case .success(let data):
                ChatDataModel.shared.otherUid = data.matchedUid
                ChatDataModel.shared.otherNick = data.matchedNick
                completion(data, statusCode, nil)
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    //MARK: - 스터디 요청
    static func studyRequest(completion: @escaping (String?, Int?, Error?) -> Void) {
        AF.request(Router.request).responseString { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    //MARK: - 스터디 수락
    static func studyAccept(completion: @escaping (String?, Int?, Error?) -> Void) {
        AF.request(Router.accept).responseString { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    //MARK: - 채팅 요청
    static func sendChat(completion: @escaping (Chat?, Int?, Error?) -> Void) {
        AF.request(ChatRouter.send).responseDecodable(of: Chat.self) { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    //MARK: - 채팅 목록 불러오기
    static func loadChat(completion: @escaping (ChatList?, Int?, Error?) -> Void) {
        AF.request(ChatRouter.list).responseDecodable(of: ChatList.self) { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    //MARK: - 스터디 취소
    static func studyCancel(completion: @escaping (String?, Int?, Error?) -> Void) {
        AF.request(ChatRouter.dodge).responseString { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    //MARK: - 스터디 리뷰 작성
    static func studyReview(completion: @escaping (String?, Int?, Error?) -> Void) {
        AF.request(QueueRouter.review).responseString { response in
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
