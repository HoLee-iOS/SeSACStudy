//
//  CancelCase.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/13.
//

import Foundation

enum CancelCase: String {
    case cancel = "스터디 취소"
    case quit = "스터디 종료"
    case review = "리뷰 등록하기"
    
    enum cancelContent: String {
        case title = "스터디를 취소하시겠습니까?"
        case description = "스터디를 취소하시면 패널티가 부과됩니다"
    }
    
    enum quitContent: String {
        case title = "스터디를 종료하시겠습니까?"
        case description = "상대방이 스터디를 취소했기 때문에\n패널티가 부과되지 않습니다"
    }
    
    enum reviewContent: String {
        case title = "님을 친구 목록에 추가할까요?"
        case description = "친구 목록에 추가하면 언제든지 채팅을 할 수 있어요"
    }
}
