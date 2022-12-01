//
//  SesacSearchTabViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/25.
//

import UIKit

import FirebaseAuth
import Tabman
import Pageboy

class SesacSearchTabViewController: TabmanViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = BlackNWhite.white
        setBarButtonItem()
        setVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func backHome() {
        self.navigationController?.popViewControllers(2)
    }
    
    //MARK: - 탭 뷰컨 설정
    func setVC() {
        self.title = "새싹 찾기"
        self.dataSource = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: Icons.backButton, style: .plain, target: self, action: #selector(backHome))
        
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
        tabBar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
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

extension SesacSearchTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    //MARK: - 탭 개수 설정
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return 2
    }
    
    //MARK: - 탭 화면 설정
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return SesacSearchViewController()
    }
    
    //MARK: - 디폴트 탭 설정
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return .first
    }
    
    //MARK: - 탭바 아이템
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0: return TMBarItem(title: "주변 새싹")
        case 1: return TMBarItem(title: "받은 요청")
        default: return TMBarItem(title: " ")
        }
    }
}

// MARK: - 찾기중단 메서드
extension SesacSearchTabViewController {
    func setBarButtonItem() {
        let navibarAppearance = UINavigationBarAppearance()
        let barbuttonItemAppearance = UIBarButtonItemAppearance()
        barbuttonItemAppearance.normal.titleTextAttributes = [.foregroundColor: BlackNWhite.black, .font: UIFont(name: Fonts.medium, size: 14)!]
        navibarAppearance.buttonAppearance = barbuttonItemAppearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopTapped))
    }
    
    @objc func stopTapped() {
        APIService.sesacStop { [weak self] (value, statusCode, error) in
            guard let statusCode = statusCode else { return }
            guard let status = NetworkError(rawValue: statusCode) else { return }
            switch status {
            case .success:
                //현재 상태에 따라 중단 버튼 화면 전환에 대한 분기 처리
                self?.navigationController?.popViewControllers(2)
            case .alreadySignUp:
                self?.view.makeToast("누군가와 스터디를 함께하기로 약속하셨어요!", position: .center, completion: { _ in
                    self?.navigationController?.pushViewController(ChattingViewController(), animated: true)
                })
            case .invalidToken: self?.refreshToken()
            default: self?.view.makeToast("\(statusCode): 잠시 후 다시 시도해주세요.")
            }
        }
    }
    
    //MARK: - 토큰 만료 시 토큰 재발급
    func refreshToken() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [weak self] token, error in
            if let error = error {
                self?.view.makeToast("에러: \(error.localizedDescription)")
                return
            } else if let token = token {
                UserDefaultsManager.token = token
                APIService.sesacStop { [weak self] (value, statusCode, error) in
                    guard let statusCode = statusCode else { return }
                    guard let status = NetworkError(rawValue: statusCode) else { return }
                    switch status {
                    case .success: self?.navigationController?.popViewControllers(2)
                    case .alreadySignUp:
                        self?.view.makeToast("누군가와 스터디를 함께하기로 약속하셨어요!", position: .center, completion: { _ in
                            self?.navigationController?.pushViewController(ChattingViewController(), animated: true)
                        })
                    default: self?.view.makeToast("잠시 후 다시 시도해주세요.")
                    }
                }
            }
        }
    }
}



