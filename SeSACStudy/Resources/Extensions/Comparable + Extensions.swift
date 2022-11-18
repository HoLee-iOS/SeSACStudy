//
//  Compatable + Extensions.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/18.
//

import Foundation

extension Comparable {
    
  func clamped(to limits: ClosedRange<Self>) -> Self {
    min(max(self, limits.lowerBound), limits.upperBound)
  }
    
}
