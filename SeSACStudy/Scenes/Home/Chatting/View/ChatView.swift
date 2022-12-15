//
//  ChatView.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/01.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard
import SnapKit

class ChatView: BaseView {
    
    let viewModel = ChatViewModel()
    
    let disposeBag = DisposeBag()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.rowHeight = UITableView.automaticDimension
        view.separatorStyle = .none
        
        view.register(DateTableViewCell.self, forCellReuseIdentifier: DateTableViewCell.reuseIdentifier)
        view.register(YourChatTableViewCell.self, forCellReuseIdentifier: YourChatTableViewCell.reuseIdentifier)
        view.register(MyChatTableViewCell.self, forCellReuseIdentifier: MyChatTableViewCell.reuseIdentifier)
        return view
    }()
    
    let chatBox: UIView = {
        let view = UIView()
        view.backgroundColor = GrayScale.gray1
        view.layer.cornerRadius = 8
        return view
    }()
    
    let chatContent: UITextView = {
        let view = UITextView()
        view.text = TextCase.Chatting.placeHolder.rawValue
        view.backgroundColor = GrayScale.gray1
        view.textColor = GrayScale.gray7
        return view
    }()
    
    let sendButton: UIButton = {
        let buttton = UIButton()
        buttton.setImage(Icons.Chat.unSend, for: .normal)
        return buttton
    }()
    
    let reportButton = MoreMenuButton(text: TextCase.Chatting.report.rawValue, image: Icons.Chat.report, type: .report)
    
    let cancelButton = MoreMenuButton(text: TextCase.Chatting.cancel.rawValue, image: Icons.Chat.cancel, type: .cancel)

    let reviewButton = MoreMenuButton(text: TextCase.Chatting.review.rawValue, image: Icons.Chat.review, type: .review)
    
    let moreMenuBack: UIView = {
        let view = UIView()
        view.backgroundColor = BlackNWhite.black
        view.alpha = 0.5
        return view
    }()
    
    lazy var moreMenu: UIStackView = {
        let view = UIStackView(arrangedSubviews: [reportButton, cancelButton, reviewButton])
        view.backgroundColor = .white
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()
    
    override func configure() {
        [sendButton, chatContent].forEach{ chatBox.addSubview($0) }
        [chatBox, tableView, moreMenuBack, moreMenu].forEach{ addSubview($0) }
        moreMenuBack.isHidden = true
        moreMenu.isHidden = true
    }
    
    override func setConstraints() {
        
        moreMenuBack.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
        moreMenu.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(72)
        }
        
        chatBox.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.08)
        }
        
        sendButton.snp.makeConstraints {
            $0.verticalEdges.trailing.equalTo(chatBox).inset(16)
            $0.width.equalTo(sendButton.snp.height)
        }
        
        chatContent.snp.makeConstraints {
            $0.leading.equalTo(chatBox).inset(12)
            $0.verticalEdges.equalTo(chatBox).inset(14)
            $0.trailing.equalTo(sendButton.snp.leading).offset(-10)
        }
        
        tableView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(chatBox.snp.top)
        }
    }
    
    override func bindData() {
        
        let input = ChatViewModel.Input(editingBegin: chatContent.rx.didBeginEditing, editingEnd: chatContent.rx.didEndEditing)
        let output = viewModel.transform(input: input)
        
        //MARK: - placeholder
        output.chatPlaceholder
            .withUnretained(self)
            .bind { (vc, status) in
                switch status {
                case .editingDidBegin:
                    vc.chatContent.text = nil
                    vc.chatContent.textColor = BlackNWhite.black
                case .editingDidEnd:
                    vc.chatContent.text = TextCase.Chatting.placeHolder.rawValue
                    vc.chatContent.textColor = GrayScale.gray7
                }
            }
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive { [unowned self] (keyboardHeight) in
                let height = keyboardHeight > 0 ? -keyboardHeight + self.safeAreaInsets.bottom : 0
                self.chatBox.snp.updateConstraints {
                    $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
                    $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(height)
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.didScroll
            .withUnretained(self)
            .bind { (vc, _) in
                vc.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        chatContent.rx.text
            .withUnretained(self)
            .bind { (vc, value) in
                vc.sendButton.setImage(value == TextCase.Chatting.placeHolder.rawValue || value?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ? Icons.Chat.unSend : Icons.Chat.send, for: .normal)
            }
            .disposed(by: disposeBag)
        
        sendButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                if vc.sendButton.currentImage == Icons.Chat.send {
                    ChatDataModel.shared.content = vc.chatContent.text
                    APIService.sendChat { value, statusCode, error in
                        guard let statusCode = statusCode else { return }
                        guard let status = NetworkError(rawValue: statusCode) else { return }
                        switch status {
                        case .success:
                            guard let value = value else { return }
                            ChatRepository.shared.saveChat(item: ChatData(chatId: value.id, toChat: value.to, fromChat: value.from, chatContent: value.chat, chatDate: value.createdAt))
                            vc.tableView.reloadData()
                            vc.tableView.scrollToRow(at: IndexPath(row: (ChatRepository.shared.tasks?.count ?? 0) - 1, section: 0), at: .bottom, animated: false)
                        default:
                            vc.showToast("잠시후 다시 요청해주세요.")
                        }
                    }
                }                
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: CellData Bind
    func cellData(cell1: DateTableViewCell, cell2: YourChatTableViewCell, cell3: MyChatTableViewCell, data: ChatData) {
        //MARK: - DateCell Data Bind
        cell1.dateLabel.text = data.chatDate.changeDateCell()
        cell1.matchingInfoLabel.text = "\(ChatDataModel.shared.otherNick)님과 매칭되었습니다"
        
        //MARK: - YourChatCell Data Bind
        cell2.chatBox.text = data.chatContent
        cell2.timeLabel.text = data.chatDate.changeDate()
        
        //MARK: - MyChatCell Data Bind
        cell3.chatBox.text = data.chatContent
        cell3.timeLabel.text = data.chatDate.changeDate()
    }
}

extension ChatView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatRepository.shared.tasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let startInfo = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.reuseIdentifier, for: indexPath) as? DateTableViewCell
        let yourChat = tableView.dequeueReusableCell(withIdentifier: YourChatTableViewCell.reuseIdentifier, for: indexPath) as? YourChatTableViewCell
        let myChat = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCell.reuseIdentifier, for: indexPath) as? MyChatTableViewCell
        
        guard let startInfo = startInfo, let yourChat = yourChat, let myChat = myChat else { return UITableViewCell() }
        guard let data = ChatRepository.shared.tasks?[indexPath.row] else { return UITableViewCell() }
        
        cellData(cell1: startInfo, cell2: yourChat, cell3: myChat, data: data)
        
        if indexPath.row == 0 { return startInfo }
        
        //내 유저아이디와 같으면 내쪽 아니면 다른쪽
        return data.fromChat == ChatDataModel.shared.myUid ? myChat : yourChat
    }
}
