//
//  ChattingViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/30.
//

import UIKit

import RxSwift
import RxCocoa
import FirebaseAuth
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
        
        //MARK: - 소켓 연결
        SocketIOManager.shared.establishConnection()
        
        //MARK: - 채팅 목록 불러오기
        loadChat()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //MARK: - 소켓 연결 해제
        SocketIOManager.shared.closeConnection()
    }
    
    //MARK: - 채팅 목록 불러오기
    func loadChat() {
        APIService.loadChat { [weak self] (value, statusCode, error) in
            guard let statusCode = statusCode else { return }
            guard let status = NetworkError(rawValue: statusCode) else { return }
            switch status {
            case .success:
                value?.payload.forEach { ChatRepository.shared.saveChat(item: ChatData(chatId: $0.id, toChat: $0.to, fromChat: $0.from, chatContent: $0.chat, chatDate: $0.createdAt)) }
                self?.chatView.tableView.reloadData()
                self?.chatView.tableView.scrollToRow(at: IndexPath(row: (ChatRepository.shared.tasks?.count ?? 0) - 1, section: 0), at: .bottom, animated: false)
            case .invalidToken: self?.refreshToken1()
            default: self?.showToast("잠시 후 다시 시도해주세요.")
            }
        }
    }
    
    //MARK: - 토큰 만료 시 토큰 재발급
    func refreshToken1() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { token, error in
            if let error = error {
                self.showToast("에러: \(error.localizedDescription)")
                return
            } else if let token = token {
                UserDefaultsManager.token = token
                APIService.loadChat { [weak self] (value, statusCode, error) in
                    guard let statusCode = statusCode else { return }
                    guard let status = NetworkError(rawValue: statusCode) else { return }
                    switch status {
                    case .success:
                        value?.payload.forEach { ChatRepository.shared.saveChat(item: ChatData(chatId: $0.id, toChat: $0.to, fromChat: $0.from, chatContent: $0.chat, chatDate: $0.createdAt)) }
                        self?.chatView.tableView.reloadData()
                        self?.chatView.tableView.scrollToRow(at: IndexPath(row: (ChatRepository.shared.tasks?.count ?? 0) - 1, section: 0), at: .bottom, animated: false)
                    default: self?.showToast("잠시 후 다시 시도해주세요.")
                    }
                }
            }
        }
    }
    
    @objc func getMessage(notification: NSNotification) {
        let id = notification.userInfo![TextCase.Chatting.ChatSokcet.id.rawValue] as! String
        let chat = notification.userInfo![TextCase.Chatting.ChatSokcet.chat.rawValue] as! String
        let createdAt = notification.userInfo![TextCase.Chatting.ChatSokcet.createdAt.rawValue] as! String
        let from = notification.userInfo![TextCase.Chatting.ChatSokcet.from.rawValue] as! String
        let to = notification.userInfo![TextCase.Chatting.ChatSokcet.to.rawValue] as! String
        
        let value = ChatData(chatId: id, toChat: to, fromChat: from, chatContent: chat, chatDate: createdAt)
        
        ChatRepository.shared.saveChat(item: value)
        chatView.tableView.reloadData()
        chatView.tableView.scrollToRow(at: IndexPath(row: (ChatRepository.shared.tasks?.count ?? 0) - 1, section: 0), at: .bottom, animated: false)
    }
    
    @objc func backHome() {
        self.navigationController?.popViewControllers(3)
    }
    
    //MARK: - 현재 상태 확인
    func updateMyState() {
        APIService.myQueueState { [weak self] (value, statusCode, error) in
            guard let statusCode = statusCode else { return }
            guard let status = NetworkError(rawValue: statusCode) else { return }
            switch status {
            case .success:
                if value?.matched == 1 { self?.chatView.cancelButton.setTitle(TextCase.Chatting.cancel.rawValue, for: .normal) }
                if value?.dodged == 1 || value?.reviewed == 1 { self?.chatView.cancelButton.setTitle(TextCase.Chatting.quit.rawValue, for: .normal) }
                self?.chatView.cancelButton.setTitleColor(BlackNWhite.black, for: .normal)
            case .invalidToken: self?.refreshToken2()
            default: self?.showToast("\(statusCode), 기타 에러")
            }
        }
    }
    
    //MARK: - 토큰 만료 시 토큰 재발급
    func refreshToken2() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { token, error in
            if let error = error {
                self.showToast("에러: \(error.localizedDescription)")
                return
            } else if let token = token {
                UserDefaultsManager.token = token
                APIService.myQueueState { [weak self] (value, statusCode, error) in
                    guard let statusCode = statusCode else { return }
                    guard let status = NetworkError(rawValue: statusCode) else { return }
                    switch status {
                    case .success:
                        if value?.matched == 1 { self?.chatView.cancelButton.setTitle("스터디 취소", for: .normal) }
                        if value?.dodged == 1 || value?.reviewed == 1 { self?.chatView.cancelButton.setTitle("스터디 종료", for: .normal) }
                        self?.chatView.cancelButton.setTitleColor(BlackNWhite.black, for: .normal)
                    default: self?.showToast("잠시 후 다시 시도해주세요.")
                    }
                }
            }
        }
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
            //MARK: - 더보기 버튼 클릭 시 사용자 상태 확인
            updateMyState()
            
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
        
        //MARK: - 새싹 신고
        chatView.reportButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.showToast("준비 중인 서비스입니다.")
            }
            .disposed(by: disposeBag)
        
        //MARK: - 스터디 취소
        chatView.cancelButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                let viewController = CancelViewController()
                viewController.type = vc.chatView.cancelButton.currentTitle ?? ""
                viewController.modalPresentationStyle = .overFullScreen                
                vc.present(viewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        //MARK: - 리뷰 등록
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
