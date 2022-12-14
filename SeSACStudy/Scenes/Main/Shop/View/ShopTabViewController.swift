//
//  ShopTabViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/13.
//

import UIKit

import Tabman
import Pageboy
import SnapKit

class ShopTabViewController: TabmanViewController {
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = BlackNWhite.white
        view.addSubview(cardView)
        cardView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(100)
        }
        setVC()
    }
    
    //MARK: - 탭 뷰컨 설정
    func setVC() {
        self.title = "새싹샵"
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        setTabBar(tabBar: bar)
        addBar(bar, dataSource: self, at: .top)
    }
    
    //MARK: - 탭 UI 설정
    func setTabBar (tabBar : TMBar.ButtonBar) {
        tabBar.backgroundView.style = .clear
        
        tabBar.layout.transitionStyle = .snap
        tabBar.layout.alignment = .centerDistributed
        tabBar.layout.contentMode = .fit
        tabBar.layout.contentInset = UIEdgeInsets(top: 100, left: 0.0, bottom: 0.0, right: 0.0)
        
        tabBar.buttons.customize { (button) in
            button.tintColor = GrayScale.gray6
            button.selectedTintColor = BrandColor.green
            button.font = UIFont(name: Fonts.regular, size: 14)!
            button.selectedFont = UIFont(name: Fonts.medium, size: 14)!
        }
        
        tabBar.indicator.weight = .custom(value: 2)
        tabBar.indicator.tintColor = BrandColor.green
        tabBar.indicator.overscrollBehavior = .compress
    }
}

extension ShopTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    //MARK: - 탭 개수 설정
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return 2
    }
    
    //MARK: - 탭 화면 설정
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return ShopViewController()
    }
    
    //MARK: - 디폴트 탭 설정
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return .first
    }
    
    //MARK: - 탭바 아이템
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0: return TMBarItem(title: "새싹")
        case 1: return TMBarItem(title: "배경")
        default: return TMBarItem(title: " ")
        }
    }
}
