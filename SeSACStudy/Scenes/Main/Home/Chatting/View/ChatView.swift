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
        
        cancelButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                print(ChatDataModel.shared.otherUid)
            }
            .disposed(by: disposeBag)
        
        sendButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                ChatDataModel.shared.content = vc.chatContent.text
                APIService.sendChat { value, statusCode, error in
                    guard let statusCode = statusCode else { return }
                    guard let status = NetworkError(rawValue: statusCode) else { return }
                    switch status {
                    case .success:
                        guard let value = value else { return }
                        ChatRepository.shared.sendChat(item: ChatData(chatId: value.id, toChat: value.to, fromChat: value.from, chatContent: value.chat, chatDate: value.createdAt))
                    default:
                        print(statusCode, "에러")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        let addTap = Observable.merge(reportButton.rx.tap.asObservable(), cancelButton.rx.tap.asObservable(), reviewButton.rx.tap.asObservable())
    }
    
    //MARK: CellData Bind
    func cellData(cell1: DateTableViewCell, cell2: YourChatTableViewCell, cell3: MyChatTableViewCell) {
        //MARK: - DateCell Data Bind
        cell1.dateLabel.text = "\(ChatDataModel.shared.date.month ?? 1)월 \(ChatDataModel.shared.date.day ?? 1)일 \(ChatDataModel.shared.date.weekday)"
        cell1.matchingInfoLabel.text = "\(ChatDataModel.shared.otherNick)님과 매칭되었습니다"
        
        //MARK: - YourChatCell Data Bind
        cell2.chatBox.text =
        cell2.timeLabel.text = "15:02"
        
        //MARK: - MyChatCell Data Bind
        cell3.chatBox.text = "안녕하세요! 저 평일은 저녁 8시에 꾸준히 하는데 7시부터 해도 괜찮아요"
        cell3.timeLabel.text = "15:02"
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
        
        cellData(cell1: startInfo, cell2: yourChat, cell3: myChat)
        
        ChatRepository.shared.tasks?.sorted(by: "chatDate")
        
        
        
        if indexPath.row == 0 { return startInfo }
        ChatRepository.shared.tasks?.filter{ $0.fromChat == ChatDataModel.shared.otherUid }
        if indexPath.row % 2 == 0 { return myChat }
        else { return yourChat }
    }
}
