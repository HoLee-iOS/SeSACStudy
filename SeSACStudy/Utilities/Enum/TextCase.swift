//
//  TextCase.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/02.
//

import Foundation

enum TextCase {
    enum Chatting: String {
        case chatInfo = "채팅을 통해 약속을 정해보세요 :)"
        case placeHolder = "메세지를 입력하세요"
        case report = "새싹 신고"
        case cancel = "스터디 취소"
        case review = "리뷰 등록"
        case quit = "스터디 종료"
        case reviewButton = "리뷰 등록하기"
        case reviewPlaceholder = " 자세한 피드백은 다른 새싹들에게 도움이 됩니다\n (500자 이내 작성)"
        enum ChatSokcet: String {
            case id = "_id"
            case chat = "chat"
            case createdAt = "createdAt"
            case from = "from"
            case to = "to"
            case defaultLastDate = "2000-01-01T00:00:00.000Z"
        }
    }
    enum Review: String {
        case manner = "좋은 매너"
        case promise = "정확한 시간 약속"
        case response = "빠른 응답"
        case kind = "친절한 성격"
        case skill = "능숙한 실력"
        case beneficial = "유익한 시간"
    }
    
    enum Shop: String {
        case save = "저장하기"
        case mine = "보유"
    }
}
