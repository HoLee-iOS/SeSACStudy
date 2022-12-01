//
//  MyQueueState.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/29.
//

import UIKit

enum MyQueueState {
    case search
    case antenna
    case message
    
    var images: UIImage? {
        switch self {
        case .search: return Icons.floatingSearch
        case .antenna: return Icons.floatingAntenna
        case .message: return Icons.floatingMessage
        }
    }
}
