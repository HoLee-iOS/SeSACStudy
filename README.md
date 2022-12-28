<img src="https://user-images.githubusercontent.com/78537078/209440172-e6e20eee-514f-4d98-a549-dde88a67812c.png" width = "20%">

# SeSACStudy

- 현재 위치 기반 주변에서 내가 원하는 사람과 스터디를 할 수 있게 1대1 채팅으로 매칭 시켜주는 앱입니다.
- 주요 기획 의도는 서비스 레벨의 기획 명세서, API 명세서와 디자인 리소스를 전달 받아서 앱 개발을 진행함으로 실제 업무 환경과 동일한 프로세스로 진행한 개인 프로젝트입니다.

</br>

<p>
<img src="https://user-images.githubusercontent.com/78537078/209194267-7c55028e-05ff-49ef-8f15-433f0f898354.png" width = "15%">
<img src="https://user-images.githubusercontent.com/78537078/209194185-3af35245-ffb2-4e14-817e-c0bbddfa1237.png" width = "15%">
<img src="https://user-images.githubusercontent.com/78537078/209194187-a4689579-f810-4a7f-b1cf-8544dbafb015.png" width = "15%">
<img src="https://user-images.githubusercontent.com/78537078/209194190-e1bff327-52da-43ac-bb65-4e4b11e66c42.png" width = "15%">
<img src="https://user-images.githubusercontent.com/78537078/209194194-458ae2b1-fe55-4536-8f4c-a788982d9024.png" width = "15%">
<img src="https://user-images.githubusercontent.com/78537078/209194520-49db17dd-d753-42fa-8252-fc713ddda990.png" width = "15%">
</p>

</br>

## 1. 제작 기간 & 참여 인원
- 개발 공수 : https://elite-pet-b14.notion.site/cc17a5f6c473445092fff749e6cfeb44
- 2022년 11월 7일 ~ 12월 10일 (5주)
- 개인 프로젝트

</br>

## 2. 사용 기술
| kind | stack |
| ------ | ------ |
| 아키텍처 | `MVC` `MVVM` `Input/output` |
| 프레임워크 | `UIKit` `Foundation` `MapKit` `Network` `StoreKit` `CoreLocation`|
| UI | `Snapkit` `Codebase` |
| 라이브러리 | `Toast` `RxSwift` `RxCocoa` `SnapKit` `RxKeyboard` `Tabman` `SocketIO` `FirebaseAuth` `FirebaseMessaging` |
| 데이터베이스 | `Realm` |
| 네트워크 | `Alamofire` |
| 의존성관리 | `Swift Package Manager` |
| Tools | `Git / Github` `Jandi` |
| ETC | `DiffableDataSource` `Compositional Layout` |

</br>

## 3. 핵심 기능

이 서비스의 핵심 기능은 검색을 통한 사용자 찾기, 사용자와의 채팅으로 스터디 일정 계획, 인앱 결제를 통한 캐릭터 꾸미기입니다.
- 검색 기능
- 채팅 기능
- 인앱 결제

<details>
<summary><b>핵심 기능 설명 펼치기</b></summary>

### 3.1 검색 기능

- 찾기 버튼 클릭 시 내가 원하는 태그 값 배열을 파라미터로 갖는 찾기 통신 실행
``` swift
func sesacSearch(completion: @escaping (String?, Int?, Error?) -> Void) {
    
    let url = UserDefaultsManager.baseURL + UserDefaultsManager.sesacPath
    
    let header: HTTPHeaders = [
        "idtoken": UserDefaultsManager.token,
        "Content-Type": "application/x-www-form-urlencoded"
    ]
    
    let parameter: [String : Any] = [
        "long": UserDefaultsManager.long,
        "lat": UserDefaultsManager.lat,
        "studylist": UserDefaultsManager.studyList.isEmpty ? ["anything"] : UserDefaultsManager.studyList
    ]
    let enc: ParameterEncoding = URLEncoding(arrayEncoding: .noBrackets)
    
    AF.request(url, method: .post, parameters: parameter, encoding: enc, headers: header).responseString { response in
        guard let statusCode = response.response?.statusCode else { return }
        switch response.result {
        case .success(let data):
            completion(data, statusCode, nil)
        case .failure(let error):
            completion(nil, statusCode, error)
        }
    }
}
```

- 통신을 통해 내 주변 태그 값 배열에 맞는 사용자들을 리스트로 구현
``` swift
func updateUI() {
    currentSnapshot = NSDiffableDataSourceSnapshot<FromQueueDB, Item>()
    let sections = pageboyPageIndex == 0 ? SesacList.aroundList : SesacList.requestList
    currentSnapshot.appendSections(sections)
    for section in sections {
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        let headerItem = Item(uid: section.uid, sesac: section.sesac, background: section.background, nick: section.nick)
        sectionSnapshot.append([headerItem])
        //let items = Item(sesac: nil, background: nil, nick: SesacList.aroundList[section].nick)
        //sectionSnapshot.append([items], to: headerItem)
        //sectionSnapshot.expand([headerItem])
        dataSource.apply(sectionSnapshot, to: section)
    }
}
```

### 3.2 채팅 기능

- 채팅 화면 진입 시 실시간 통신을 위한 소켓 연결
``` swift
socket.on(clientEvent: .connect) { data, ack in
    print("SOCKET IS CONNECTED", data, ack)
    self.socket.emit("changesocketid", ChatDataModel.shared.myUid)
}

SocketIOManager.shared.establishConnection()
```

- 이전 대화 기록 로드 후 채팅창에 나타냄
``` swift
APIService.loadChat { [weak self] (value, statusCode, error) in
    guard let statusCode = statusCode else { return }
    guard let status = NetworkError(rawValue: statusCode) else { return }
    switch status {
    case .success:
        value?.payload.forEach { ChatRepository.shared.saveChat(item: ChatData(chatId: $0.id, toChat: $0.to, fromChat: $0.from, chatContent: $0.chat, chatDate: $0.createdAt)) }
        self?.chatView.tableView.reloadData()
        if ChatRepository.shared.tasks?.count ?? 0 > 0 { 
        self?.chatView.tableView.scrollToRow(at: IndexPath(row: (ChatRepository.shared.tasks?.count ?? 0) - 1, section: 0), at: .bottom, animated: false)
        }
```

- 채팅 수신 시 NotificationCenter를 통해 값을 전달
``` swift
socket.on(TextCase.Chatting.ChatSokcet.chat.rawValue) { dataArray, ack in
    print("CHAT RECEIVED", dataArray, ack)
    
    //인코딩되어있는 내용을 타입캐스팅을 통해 알아볼 수 있게 변환함
    let data = dataArray[0] as! NSDictionary
    let id = data[TextCase.Chatting.ChatSokcet.id.rawValue] as! String
    let chat = data[TextCase.Chatting.ChatSokcet.chat.rawValue] as! String
    let createdAt = data[TextCase.Chatting.ChatSokcet.createdAt.rawValue] as! String
    let from = data[TextCase.Chatting.ChatSokcet.from.rawValue] as! String
    let to = data[TextCase.Chatting.ChatSokcet.to.rawValue] as! String
    
    NotificationCenter.default.post(name: NSNotification.Name("getMessage"), object: self, userInfo: [TextCase.Chatting.ChatSokcet.id.rawValue: id, TextCase.Chatting.ChatSokcet.chat.rawValue: chat, TextCase.Chatting.ChatSokcet.createdAt.rawValue: createdAt, TextCase.Chatting.ChatSokcet.from.rawValue: from, TextCase.Chatting.ChatSokcet.to.rawValue: to])
}
```

- NotificationCenter를 통해 전달받은 값을 채팅창에 실시간으로 나타냄
``` swift
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
```

- 채팅 전송 버튼 클릭 시 네트워크 통신 후 성공 했을 경우 채팅창에 나타냄
``` swift
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
```

### 3.3 인앱 결제

- 인앱 상품 ID 정의
``` swift
var productIdentifiers: Set<String> = ["com.memolease.sesac1.sprout1", "com.memolease.sesac1.sprout2", "com.memolease.sesac1.sprout3", "com.memolease.sesac1.sprout4", "com.memolease.sesac1.background1", "com.memolease.sesac1.background2", "com.memolease.sesac1.background3", "com.memolease.sesac1.background4", "com.memolease.sesac1.background5", "com.memolease.sesac1.background6", "com.memolease.sesac1.background7"]
```

- 정의된 상품 ID에 대한 정보 가져오기 및 사용자의 디바이스가 인앱결제가 가능한지 여부 확인
``` swift
if SKPaymentQueue.canMakePayments() {
    let request = SKProductsRequest(productIdentifiers: productIdentifiers)
    request.delegate = self
    request.start()
} else {
    print("In App Purchase Not Enabled")
}
```

- 인앱 상품 정보 조회
``` swift
func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    
    let products = response.products
    
    if products.count > 0 {
        
        for i in products {
            productArray.append(i)
            //product = i //옵션. 테이블뷰 셀에서 구매하기 버튼 클릭 시, 버튼 클릭 시
            
            print(i.localizedTitle, i.price, i.priceLocale, i.localizedDescription)
        }
    } else {
        print("No Product Found") //계약 업데이트. 유료 계약 X. Capabilities X
    }
}
```

- 가격 버튼 클릭 시 인앱 결제 시작
``` swift
func purchaseStart(product: SKProduct) {
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(payment)
    SKPaymentQueue.default().add(self)
}
```

- 구매 상태 Observing
``` swift
func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    
    for transaction in transactions {
        switch transaction.transactionState {
        case .purchased: 
            receiptValidation(transaction: transaction, productIdentifier: transaction.payment.productIdentifier)
        case .failed: 
            SKPaymentQueue.default().finishTransaction(transaction)
        default:
            break
        }
    }
}
```

- 구매 상태가 승인으로 되었을 경우 영수증 검증
``` swift
func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String) { [weak self]    
    let receiptFileURL = Bundle.main.appStoreReceiptURL
    let receiptData = try? Data(contentsOf: receiptFileURL!)
    let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    
    ShopDataModel.shared.receipt = receiptString ?? ""
    ShopDataModel.shared.product = productIdentifier
    SKPaymentQueue.default().finishTransaction(transaction)
    self?.inApp()
}
```

- 데이터 통신을 통해 결제가 확인되면 보유중인 아이템으로 변경
``` swift
func inApp() {
    APIService.inApp { [weak self] (value, statusCode, error) in
        guard let statusCode = statusCode else { return }
        guard let status = NetworkError(rawValue: statusCode) else { return }
        switch status {
        case .success: self?.loadMyInfo()
        case .invalidToken: self?.refreshToken2()
        default: self?.makeToast("잠시 후 다시 시도해 주세요.")
        }
    }
}
```
</details>

</br>

## 4. 트러블슈팅
- 개발 일지 : https://elite-pet-b14.notion.site/4fc049aaeaa94976a583790289a6e630
### 4.1 Compositional Layout 에러
- 문제점: 내가 하고 싶은 스터디를 추가 후에 삭제하고 다시 추가하면 레이아웃이 겹치는 현상 발생
- 해결: preferredLayoutAttributesFitting을 이용하여 스터디를 추가하고 뷰 갱신 했을 때 해당 메서드가 실행되며 지정해놓은 size에 맞춰 layout이 겹치지 않게 구현함
    <img width="1175" alt="스크린샷 2022-12-28 오후 5 22 43" src="https://user-images.githubusercontent.com/78537078/209781699-bbf86f9d-c406-41b7-8c7c-a20bacd4f2e8.png">

### 4.2 lessThanOrEqualTo, greaterThanOrEqualTo 
- 문제점: 채팅 말풍선이 일정 이상의 inset을 넘어가지 않게 lessThanOrEqualTo을 이용해서 제약조건을 설정했는데 trailing 제약조건에서는 잘 동작하는데 leading에서는 동작하지 않음
- 해결: layout의 제약조건에서 leading 기준에서 trailing 방향으로 갈 수록 offset의 값이 커지기 때문에 leading 기준으로 일정 offset 이상 넘어가지 못하게 하려면 trailing 기준과 반대로 greaterThanOrEqualTo를 사용해야함
    <img width="609" alt="5" src="https://user-images.githubusercontent.com/78537078/209783322-d3314068-506e-4121-adfc-3f37c679fb66.png">
    <img width="616" alt="6" src="https://user-images.githubusercontent.com/78537078/209783330-c24cab07-c40f-48ec-81cf-0891e1a6dc3c.png">

### 4.3 Brackets
- 문제점: 네트워크 통신 시 값을 Post하는 상황에서 배열을 바디로 넣어줬는데 501 에러가 뜨며 통신에 실패함
    - 501 에러: 서버로 Post 하는 데이터 형태가 올바르지 않음
- 해결: Alamofire에서는 배열을 바디 값으로 Post할 때 브라켓이라는 빈배열을 넣어 인코딩 후 통신해야하므로 `.noBrackets`으로 빈배열을 넣어서 해결함</br>
    <img width="636" alt="스크린샷 2022-12-28 오후 5 41 01" src="https://user-images.githubusercontent.com/78537078/209784051-b51bbde4-f0b8-4cb2-97c9-c1ef76515589.png">
    
### 4.4 네트워크 통신 과다 호출 막기
- 문제점: 지도를 움직일 때나 내 위치 버튼을 누를 때마다 주변 사용자 찾기 통신이 실행되어 네트워크 통신이 과호출이 되는 경우가 생김
- 해결: 지도를 움직인 후에 interaction을 0.8초 동안 막아서 지도를 막 움직여서 과호출 되는 경우를 막음
    - limit이라는 Bool 타입의 전역변수를 통해 0.8초에 한번씩만 통신이 가능하게 하여 과호출 되는 경우를 막음 
    <img width="728" alt="스크린샷 2022-12-28 오후 6 02 31" src="https://user-images.githubusercontent.com/78537078/209787671-75ca975c-88ab-4d56-99b6-c3ce976dddad.png">
    <img width="667" alt="스크린샷 2022-12-28 오후 6 02 53" src="https://user-images.githubusercontent.com/78537078/209787687-0f348493-14d9-4586-93d1-1ecd33a16295.png">
    <img width="714" alt="스크린샷 2022-12-28 오후 6 08 01" src="https://user-images.githubusercontent.com/78537078/209787697-5fbfe6ef-c7a3-472b-ba6c-6cedcef0b14d.png">

### 4.5 커스텀 버튼
- 문제점: 버튼의 UI가 다 같고 클릭 시에 변경되는 색상도 다 같은데 같은 코드 중복이 많음
- 해결: 커스텀 버튼을 만들어서 하나의 파일에서 버튼을 생성하여 중복 코드를 제거함 
    - enum을 통해 내부에 들어가는 내용을 분기처리하고 Rx를 이용하여 버튼 클릭 시에 색상 변경도 커스텀 버튼 내부에서 처리해줌 
    <img width="757" alt="스크린샷 2022-12-28 오후 6 14 23" src="https://user-images.githubusercontent.com/78537078/209788460-f282af67-afc3-4524-a0b6-efe72ffc0664.png">

### 4.6 텍스트필드 편집 상태
- 문제점: 텍스트필드 편집 상태에 따라 처리해줄 코드가 많은데 상태마다 코드를 따로 작성해줘야해서 같은 코드 중복이 많음
- 해결: 텍스트필드 편집 상태를 enum으로 만들고 상태를 enum으로 치환한 후에 하나의 Observable로 만들어서 중복 코드를 제거함
    <img width="1083" alt="스크린샷 2022-12-28 오후 6 22 44" src="https://user-images.githubusercontent.com/78537078/209789477-4d7d5acf-79d7-49ca-bbe4-6e5520a69806.png">
    <img width="1109" alt="스크린샷 2022-12-28 오후 6 23 01" src="https://user-images.githubusercontent.com/78537078/209789507-d766da2e-d98a-43e6-954e-4fefe3f586af.png">

</br>

## 5. 회고
- 프로젝트 개발에 대한 회고 : https://skylert.tistory.com/63
