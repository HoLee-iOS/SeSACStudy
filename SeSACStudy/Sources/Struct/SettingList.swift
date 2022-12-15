//
//  SettingList.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/14.
//

import Foundation
import UIKit

struct SettingList: Hashable {
    let image: UIImage?
    let title: String
    let moreView: UIImage?
    
    static let contents: [SettingList] = [
        SettingList(image: SesacFace(rawValue: MyData.shared.sesac)?.image, title: UserDefaultsManager.nickname, moreView: Icons.moreView),
        SettingList(image: Icons.settingNotice, title: "공지사항", moreView: nil),
        SettingList(image: Icons.settingFAQ, title: "자주 묻는 질문", moreView: nil),
        SettingList(image: Icons.settingQNA, title: "1:1 문의", moreView: nil),
        SettingList(image: Icons.settingAlarm, title: "알림 설정", moreView: nil),
        SettingList(image: Icons.settingPermit, title: "이용약관", moreView: nil)
    ]
}
