//
//  MainTabBarController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/14.
//

import UIKit

class MainTabBarController: UITabBarController {

    let myPageVC = MyPageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = BrandColor.green
        tabBar.unselectedItemTintColor = GrayScale.gray6
        
        myPageVC.title = "내정보"
        
        myPageVC.tabBarItem.image = Icons.mypageTab
        
        let mypageTab = UINavigationController(rootViewController: myPageVC)
        
        setViewControllers([mypageTab], animated: false)
    }
}
