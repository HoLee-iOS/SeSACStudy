//
//  SesacImages.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/30.
//

import UIKit

enum SesacFace: Int {
    case face1
    case face2
    case face3
    case face4
    case face5
    
    var images: UIImage? {
        switch self {
        case .face1: return Icons.sesacFace1
        case .face2: return Icons.sesacFace2
        case .face3: return Icons.sesacFace3
        case .face4: return Icons.sesacFace4
        case .face5: return Icons.sesacFace5
        }
    }
}

enum SesacBackground: Int {
    case back1
    case back2
    case back3
    case back4
    case back5
    case back6
    case back7
    case back8
    case back9
    
    var images: UIImage? {
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
}
