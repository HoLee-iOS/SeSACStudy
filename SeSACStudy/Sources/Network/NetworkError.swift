//
//  NetworkError.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/14.
//

import Foundation

enum NetworkError: Int {
    case success = 200
    case alreadySignUp = 201
    case invalidNick = 202
    case invalidToken = 401
    case needSignUp = 406
    case serverError = 500
    case clientError = 501
    
    var errorDescription: String {
        switch self {
        case .success: return "로그인 성공"
        case .alreadySignUp: return "이미 가입한 유저"
        case .invalidNick: return "사용할 수 없는 닉네임"
        case .invalidToken: return "토큰 만료"
        case .needSignUp: return "미가입 회원"
        case .serverError: return "서버 에러"
        case .clientError: return "잘못된 요청"
        }
    }
}
