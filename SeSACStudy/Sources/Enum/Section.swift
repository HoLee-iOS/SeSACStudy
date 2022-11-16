//
//  Section.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/15.
//

import Foundation
import UIKit

enum Section: Int, Hashable, CaseIterable {
    case main = 0
    case sub
}

struct dummy: Hashable {
    let profile: UIImage?
    var name: String?
    private let id = UUID()
    
    static func contents() -> [dummy] {
        return [dummy(profile: Icons.sesacFace1, name: UserDefaultsManager.nickname)]
    }
}
