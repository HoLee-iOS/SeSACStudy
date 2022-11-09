//
//  TargetedControlEvent.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/10.
//

import UIKit

struct TargetedControlEvent<T> {
    var event: UIControl.Event
    var target: T
}
