//
//  UINavigationController + Extensions.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/30.
//

import UIKit

extension UINavigationController {
    
    func push(_ viewControllers: [UIViewController]) {
        setViewControllers(self.viewControllers + viewControllers, animated: true)
    }
    
    func popViewControllers(_ count: Int) {
        guard viewControllers.count > count else { return }
        popToViewController(viewControllers[viewControllers.count - count - 1], animated: true)
    }   
}
