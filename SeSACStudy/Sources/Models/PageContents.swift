//
//  PageContents.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/09.
//

import UIKit

struct PageContents {
    let strings: String
    let imgs: UIImage?
    
    static let contents: [PageContents] = [
        PageContents(strings: "위치 기반으로 빠르게\n주위 친구를 확인", imgs: Icons.onboarding1),
        PageContents(strings: "스터디를 원하는 친구를\n찾을 수 있어요", imgs: Icons.onboarding2),
        PageContents(strings: "SeSAC Study", imgs: Icons.onboarding3)
    ]
}

