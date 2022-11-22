//
//  AnnotationType.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/22.
//

import MapKit

final class AnnotationType: MKPointAnnotation {
    var identifier: Int
    
    init(_ identifier: Int) {
        self.identifier = identifier
    }
}
