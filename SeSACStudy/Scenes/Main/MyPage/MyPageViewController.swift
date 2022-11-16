//
//  MyPageViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/14.
//

import UIKit
import SnapKit

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
        self.navigationController?.pushViewController(MyInfoViewController(), animated: true)
    }
}


