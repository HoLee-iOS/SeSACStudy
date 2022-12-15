//
//  InfoData.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/26.
//

import UIKit

struct InfoData: Hashable {
    let profile: UIImage?
    var name: String?
    private let id = UUID()
    
    static func contents() -> [InfoData] {
        return [InfoData(profile: SesacFace(rawValue: MyDataModel.shared.sesac)?.image, name: UserDefaultsManager.nickname)]
    }
}
