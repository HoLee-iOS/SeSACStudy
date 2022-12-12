//
//  ChattingViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/30.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class ChattingViewController: BaseViewController {
    
    let chatView = ChatView()
    
    let disposeBag = DisposeBag()
    
    var more = true
    
    override func loadView() {
        self.view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         ChatRepository.shared.fetch()
        //on chat으로 받은 이벤트를 처리하기 위한 Notification Observer
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage), name: NSNotification.Name("getMessage"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        SocketIOManager.shared.closeConnection()
    }
    
    @objc func getMessage(notification: NSNotification) {
            
        let chat = notification.userInfo!["chat"] as! String
        let name = notification.userInfo!["name"] as! String
        let createdAt = notification.userInfo!["createdAt"] as! String
        let userID = notification.userInfo!["userId"] as! String
        
        
        
        let value = Chat(text: chat, userID: userID, name: name, username: "", id: "", createdAt: createdAt, updatedAt: "", v: 0, ID: "")
        
        self.chat.append(value)
        chatView.tableView.reloadData()
        chatView.tableView.scrollToRow(at: IndexPath(row: self.chat.count - 1, section: 0), at: .bottom, animated: false)
    }
    
    @objc func backHome() {
        self.navigationController?.popViewControllers(3)
    }
    
    @objc func moreTapped() {
        more.toggle()
        
        if more {
            chatView.moreMenuBack.isHidden = more
            
            chatView.moreMenu.isHidden = more
            
            chatView.moreMenu.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
            }
        } else {
            chatView.moreMenuBack.isHidden = more
            
            chatView.moreMenu.isHidden = more
            
            chatView.moreMenu.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(72)
            }
            
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func hideMoreMenu() {
        if !more {
            chatView.moreMenuBack.isHidden = true
            
            chatView.moreMenu.isHidden = true
            
            chatView.moreMenu.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
            }
            
            more.toggle()
        }
        
        self.view.endEditing(true)
    }
    
    override func configure() {
        self.title = ChatDataModel.shared.otherNick
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideMoreMenu)))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: Icons.backButton, style: .plain, target: self, action: #selector(backHome))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Icons.Chat.more, style: .plain, target: self, action: #selector(moreTapped))
    }
    
    override func bindData() {
        chatView.reviewButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                if !vc.more {
                    vc.chatView.moreMenuBack.isHidden = true
                    
                    vc.chatView.moreMenu.isHidden = true
                    
                    vc.chatView.moreMenu.snp.updateConstraints {
                        $0.bottom.equalTo(vc.view.safeAreaLayoutGuide.snp.top)
                    }
                    
                    vc.more.toggle()
                }
                let viewController = ReviewViewController()
                viewController.modalPresentationStyle = .overFullScreen
                vc.present(viewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
