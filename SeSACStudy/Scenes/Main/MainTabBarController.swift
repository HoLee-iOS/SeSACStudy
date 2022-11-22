//
//  MainTabBarController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/14.
//

import UIKit

class MainTabBarController: UITabBarController {

    let mapVC = HomeViewController()
    let myPageVC = MyPageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = BrandColor.green
        tabBar.unselectedItemTintColor = GrayScale.gray6
        
        mapVC.title = "홈"
        myPageVC.title = "내정보"
        
        mapVC.tabBarItem.image = Icons.homeTab
        myPageVC.tabBarItem.image = Icons.mypageTab
        
        let mapTab = UINavigationController(rootViewController: mapVC)
        let mypageTab = UINavigationController(rootViewController: myPageVC)
        
        setViewControllers([mapTab, mypageTab], animated: false)
    }
}
