//
//  MainTabBarController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/14.
//

import UIKit

class MainTabBarController: UITabBarController {

    let mapVC = HomeViewController()
    let shopVC = ShopTabViewController()
    let myPageVC = MyPageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = BrandColor.green
        tabBar.unselectedItemTintColor = GrayScale.gray6
        
        mapVC.title = "홈"
        shopVC.title = "새싹샵"
        myPageVC.title = "내정보"
        
        mapVC.tabBarItem.image = Icons.homeTab
        shopVC.tabBarItem.image = Icons.shopTab
        myPageVC.tabBarItem.image = Icons.mypageTab
        
        let mapTab = UINavigationController(rootViewController: mapVC)
        let shopTab = UINavigationController(rootViewController: shopVC)
        let mypageTab = UINavigationController(rootViewController: myPageVC)
        
        setViewControllers([mapTab, shopTab, mypageTab], animated: false)
    }
}
