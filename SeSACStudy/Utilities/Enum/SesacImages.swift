//
//  SesacImages.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/30.
//

import UIKit

enum SesacFace: Int, CaseIterable {
    case face1
    case face2
    case face3
    case face4
    case face5
    
    var image: UIImage? {
        switch self {
        case .face1: return Icons.sesacFace1
        case .face2: return Icons.sesacFace2
        case .face3: return Icons.sesacFace3
        case .face4: return Icons.sesacFace4
        case .face5: return Icons.sesacFace5
        }
    }
    
    var name: String {
        switch self {
        case .face1: return "기본 새싹"
        case .face2: return "튼튼 새싹"
        case .face3: return "민트 새싹"
        case .face4: return "퍼플 새싹"
        case .face5: return "골드 새싹"
        }
    }
    
    var price: String {
        switch self {
        case .face1: return "0"
        case .face2: return "1200"
        case .face3: return "2500"
        case .face4: return "2500"
        case .face5: return "2500"
        }
    }
    
    var description: String {
        switch self {
        case .face1: return "새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다."
        case .face2: return "잎이 하나 더 자라나고 튼튼해진 새나라의 새싹으로 같이 있으면 즐거워집니다."
        case .face3: return "호불호의 대명사! 상쾌한 향이 나서 허브가 대중화된 지역에서 많이 자랍니다."
        case .face4: return "감정을 편안하게 쉬도록 하며 슬프고 우울한 감정을 진정시켜주는 멋진 새싹입니다."
        case .face5: return "화려하고 멋있는 삶을 살며 돈과 인생을 플렉스 하는 자유분방한 새싹입니다."
        }
    }
}

enum SesacBackground: Int, CaseIterable {
    case back1
    case back2
    case back3
    case back4
    case back5
    case back6
    case back7
    case back8
    case back9
    
    var image: UIImage? {
        switch self {
        case .back1: return Icons.sesacBack1
        case .back2: return Icons.sesacBack2
        case .back3: return Icons.sesacBack3
        case .back4: return Icons.sesacBack4
        case .back5: return Icons.sesacBack5
        case .back6: return Icons.sesacBack6
        case .back7: return Icons.sesacBack7
        case .back8: return Icons.sesacBack8
        case .back9: return Icons.sesacBack9
        }
    }
    
    var name: String {
        switch self {
        case .back1: return "하늘 공원"
        case .back2: return "씨티 뷰"
        case .back3: return "밤의 산책로"
        case .back4: return "낮의 산책로"
        case .back5: return "연극 무대"
        case .back6: return "라틴 거실"
        case .back7: return "홈트방"
        case .back8: return "뮤지션 작업실"
        case .back9: return "도예가 작업실"
        }
    }
    
    var price: String {
        switch self {
        case .back1: return "0"
        case .back2: return "1200"
        case .back3: return "1200"
        case .back4: return "1200"
        case .back5: return "2500"
        case .back6: return "2500"
        case .back7: return "2500"
        case .back8: return "2500"
        case .back9: return "2500"
        }
    }
    
    var description: String {
        switch self {
        case .back1: return "새싹들을 많이 마주치는 매력적인 하늘 공원입니다"
        case .back2: return "창밖으로 보이는 도시 야경이 아름다운 공간입니다"
        case .back3: return "어둡지만 무섭지 않은 조용한 산책로입니다"
        case .back4: return "즐겁고 가볍게 걸을 수 있는 산책로입니다"
        case .back5: return "연극의 주인공이 되어 연기를 펼칠 수 있는 무대입니다"
        case .back6: return "모노톤의 따스한 감성의 거실로 편하게 쉴 수 있는 공간입니다"
        case .back7: return "집에서 운동을 할 수 있도록 기구를 갖춘 방입니다"
        case .back8: return "여러가지 음악 작업을 할 수 있는 작업실입니다"
        case .back9: return "여러가지 도예 작업을 할 수 있는 작업실입니다"
        }
    }
}
