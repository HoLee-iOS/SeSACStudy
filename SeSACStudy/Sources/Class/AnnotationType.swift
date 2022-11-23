//
//  AnnotationType.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/22.
//

import MapKit

final class AnnotationType: MKPointAnnotation {
    var gender: Int
    var identifier: Int
    
    init(_ identifier: Int, gender: Int) {
        self.identifier = identifier
        self.gender = gender
    }
}
