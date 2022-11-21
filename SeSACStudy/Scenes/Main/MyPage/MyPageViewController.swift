//
//  MyPageViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/14.
//

import UIKit
import SnapKit
import FirebaseAuth

class MyPageViewController: BaseViewController {
    
    let tableView: UITableView = {
        let view = UITableView()
        view.tableHeaderView = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyNameTableViewCell.self, forCellReuseIdentifier: MyNameTableViewCell.reuseIdentifier)
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func configure() {
        view.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingList.contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell1 = tableView.dequeueReusableCell(withIdentifier: MyNameTableViewCell.reuseIdentifier) as? MyNameTableViewCell else { return  UITableViewCell() }
        guard let cell2 = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.reuseIdentifier) as? MyPageTableViewCell else { return UITableViewCell() }
        let contents = SettingList.contents[indexPath.row]
        if indexPath.row == 0 {
            tableView.rowHeight = 100
            cell1.selectionStyle = .none
            cell1.cellTitle.text = contents.title
            cell1.cellImage.image = contents.image
            cell1.moreViewImage.image = contents.moreView
            return cell1
        } else {
            tableView.rowHeight = 80
            cell2.selectionStyle = .none
            cell2.cellTitle.text = contents.title
            cell2.cellImage.image = contents.image
            return cell2
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            APIService.login { [weak self] value, statusCode, error in
                guard let statusCode = statusCode else { return }
                guard let networkErr = NetworkError(rawValue: statusCode) else { return }
                
                switch networkErr {
                case .success:
                    //MARK: - 로그인 통신 성공 시 값 받아오기                    
                    UserDefaultsManager.gender = value?.gender ?? 2
                    UserDefaultsManager.study = value?.study ?? ""
                    UserDefaultsManager.searchable = value?.searchable ?? 0
                    UserDefaultsManager.ageMin = value?.ageMin ?? 18
                    UserDefaultsManager.ageMax = value?.ageMax ?? 65
                    self?.navigationController?.pushViewController(MyInfoViewController(), animated: true)
                case .invalidToken: self?.refreshToken()
                default: self?.showToast("\(networkErr.errorDescription)")
                }
            }
        } else {
            showToast("준비 중인 서비스입니다.")
        }
    }
    
    //MARK: - 토큰 만료 시 토큰 재발급
    func refreshToken() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { token, error in
            if let error = error as? NSError {
                guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
                switch errorCode {
                default: self.showToast("에러: \(error.localizedDescription)")
                }
                return
            } else if let token = token {
                UserDefaultsManager.token = token
                APIService.login { [weak self] (value, status, error) in
                    guard let status = status else { return }
                    guard let networkCode = NetworkError(rawValue: status) else { return }
                    switch networkCode {
                    case .success: self?.navigationController?.pushViewController(MyInfoViewController(), animated: true)
                    default: self?.showToast("잠시 후 다시 시도해 주세요.")
                    }
                }
            }
        }
    }
}


