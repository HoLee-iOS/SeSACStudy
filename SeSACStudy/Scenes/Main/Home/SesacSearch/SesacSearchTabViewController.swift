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
    
    //MARK: - 타이머 객체 생성
    var apiTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - 라이프 사이클에 맞게 타이머 초기화
        apiTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateUserState(sender:)), userInfo: nil, repeats: true)
        
        view.backgroundColor = BlackNWhite.white
        setBarButtonItem()
        setVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        //MARK: - 화면 진입 시 바로 상태 확인
        updateUserState(sender: apiTimer)
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
    
    //MARK: - 5초마다 상태 확인
    @objc func updateUserState(sender: Timer) {
        APIService.myQueueState { [weak self] (value, statusCode, error) in
            guard let statusCode = statusCode else { return }
            guard let status = NetworkError(rawValue: statusCode) else { return }
            switch status {
            case .success:
                if value?.matched == 1 {
                    //MARK: - 찾기 중단 시 타이머 중지
                    self?.apiTimer.invalidate()
                    self?.view.makeToast("\(value?.matchedNick ?? "")님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다", position: .center, completion: { _ in
                        self?.navigationController?.pushViewController(ChattingViewController(), animated: true)
                    })
                }
            case .invalidToken: self?.refreshToken1()
            default: self?.view.makeToast("\(statusCode), 기타 에러")
            }
        }
    }
    
    //MARK: - 토큰 만료 시 토큰 재발급
    func refreshToken1() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { token, error in
            if let error = error {
                self.view.makeToast("에러: \(error.localizedDescription)")
                return
            } else if let token = token {
                UserDefaultsManager.token = token
                APIService.myQueueState { [weak self] (value, statusCode, error) in
                    guard let statusCode = statusCode else { return }
                    guard let status = NetworkError(rawValue: statusCode) else { return }
                    switch status {
                    case .success:
                        if value?.matched == 1 {
                            //MARK: - 찾기 중단 시 타이머 중지
                            self?.apiTimer.invalidate()
                            self?.view.makeToast("\(value?.matchedNick ?? "")님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다", position: .center, completion: { _ in
                                self?.navigationController?.pushViewController(ChattingViewController(), animated: true)
                            })
                        }
                    default: self?.view.makeToast("잠시 후 다시 시도해주세요.")
                    }
                }
            }
        }
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
                //MARK: - 찾기 중단 시 타이머 중지
                self?.apiTimer.invalidate()
                //현재 상태에 따라 중단 버튼 화면 전환에 대한 분기 처리
                self?.navigationController?.popViewControllers(2)
            case .alreadySignUp:
                //MARK: - 찾기 중단 시 타이머 중지
                self?.apiTimer.invalidate()
                self?.view.makeToast("누군가와 스터디를 함께하기로 약속하셨어요!", position: .center, completion: { _ in
                    self?.navigationController?.pushViewController(ChattingViewController(), animated: true)
                })
            case .invalidToken: self?.refreshToken2()
            default: self?.view.makeToast("\(statusCode): 잠시 후 다시 시도해주세요.")
            }
        }
    }
    
    //MARK: - 토큰 만료 시 토큰 재발급
    func refreshToken2() {
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
                    case .success:
                        //MARK: - 찾기 중단 시 타이머 중지
                        self?.apiTimer.invalidate()
                        self?.navigationController?.popViewControllers(2)
                    case .alreadySignUp:
                        //MARK: - 찾기 중단 시 타이머 중지
                        self?.apiTimer.invalidate()
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



