//
//  PageContents.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/09.
//

import UIKit

struct PageContents {
    let highlight: String?
    let strings: String
    let imgs: UIImage?
    
    static let contents: [PageContents] = [
        PageContents(highlight: "위치 기반", strings: "으로 빠르게\n주위 친구를 확인", imgs: Icons.onboarding1),
        PageContents(highlight: "스터디를 원하는 친구", strings: "를\n찾을 수 있어요", imgs: Icons.onboarding2),
        PageContents(highlight: nil, strings: "SeSAC Study", imgs: Icons.onboarding3)
    ]
}

