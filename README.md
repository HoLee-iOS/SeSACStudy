<img src="https://user-images.githubusercontent.com/78537078/209440172-e6e20eee-514f-4d98-a549-dde88a67812c.png" width = "20%">

# SeSACStudy

- 현재 위치 기반 주변에서 내가 원하는 사람에게 스터디 요청 및 수락을 통해 1대1 채팅으로 사용자를 매칭 시켜주는 서비스로 디자인 및 서버와의 협업을 통해 제작하였습니다.
- 회원 인증 로직 구현 / 1대1 채팅 구현 / 인앱결제 구현 / 원격 알림 로직 구현 

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
- 백엔드, 디자인 협업 프로젝트

</br>

## 2. 사용 기술
| kind | stack |
| ------ | ------ |
| 아키텍처 | `MVC` `MVVM` `Input/output` |
| 프레임워크 | `UIKit` `Foundation` `MapKit` `Network` `StoreKit` `CoreLocation`|
| 라이브러리 | `Toast` `SnapKit` `RxSwift` `RxCocoa` `RxKeyboard` `Tabman` `SocketIO` `FirebaseAuth` `FirebaseMessaging` |
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
    
### 4.7 의존성 관리
```
objc[43893]: Class _TtC7RxCocoa26RxTableViewDataSourceProxy is implemented in both /private/var/containers/Bundle/Application/12866EDD-3CF2-480A-B88F-DA7161164507/SeSACStudy.app/Frameworks/RxCocoa.framework/RxCocoa (0x105f5ac60) and /private/var/containers/Bundle/Application/12866EDD-3CF2-480A-B88F-DA7161164507/SeSACStudy.app/SeSACStudy (0x101ed3cb0). One of the two will be used. Which one is undefined.
```
- 문제점: RxKeyboard를 CocoaPod으로 추가한 순간부터 디버깅 창에 위와 같은 오류가  발생함.
    - 빌드에는 문제가 없지만 디버깅창에 계속 같은 에러가 발생
    - 처음에는 디바이스 캐싱의 문제인가 해서 디바이스 캐싱의 초기화를 위해 실기기를 껏켰해보고 앱을 삭제 했다가 재설치했지만 해결되지 않음
- 해결: RxKeyboard 라이브러리에서 갖고 있는 파일명과 SPM으로 설치한 Rx 관련 라이브러리가 갖고 있는 파일명이 다른 의존성 관리 툴로 관리되고 있어서 중복되는 상황이 발생한 것으로 보임
    - RxKeyboard를 삭제하고 프로젝트에서 CocoaPod을 제거한 후에 SPM으로 다시 RxKeyboard를 추가하여 해결

</br>

## 5. 회고
- 프로젝트 개발에 대한 회고 원문 : https://skylert.tistory.com/63

### Keep

- enum 활용
    - Raw한 값들을 enum을 통해 만들어서 하나의 enum 에서 모든 Raw한 값들을 관리하게 하여 유지보수에 좀 더 수월하게 함
    - 프로젝트에서 필요한 Image Asset, 폰트, 색상과 같은 리소스들을 enum을 통해 관리하여 사용에 좀 더 수월하게 함
    - 텍스트필드 편집 상태를 enum으로 만들고 상태를 enum으로 치환한 후에 하나의 Observable로 만들어서 중복 코드를 제거함
    - enum을 통해 같은 UI지만 다른 값을 가지고 있는 부분들을 관리하여 유지보수 및 사용에 수월하게 함
- Error Handling의 세세한 처리
    - 기획서에 statusCode 별로 나와있는 Error에 대한 처리가 너무 명확했기 때문에 통신 코드에서 statusCode에 맞는 enum을 만들어서 그에 맞게 Error Handling을 명확하게 처리해주었다.
    - 기획서가 개발자가 놓칠 수 있는 부분들을 명세해줌으로서 기획의 중요성을 다시 한번 느낄 수 있었다.
- URLRequestConvertible 활용
    - URLRequestConvertible을 채택한 enum으로 API 통신에 필요한 값들을 한 파일에서 관리함으로 유지보수 및 새로운 통신 코드 추가를 수월하게 함
    - 추후에 백엔드 쪽에서 API 통신의 baseURL의 포트 번호를 변경한 일이 있었는데 URLRequestConvertible을 통해 관리하여 정말 간단하게 변경이 가능했다.
- 반복되는 UI 재사용
    - 반복되는 버튼은 하나의 커스텀 버튼을 생성하여 중복 코드를 제거하고 enum을 통해 내부에 들어가는 내용을 분기처리, Rx를 이용하여 버튼 클릭 시에 색상 변경도 커스텀 버튼 내부에서 처리해 줌
    - 반복되는 팝업 화면은 하나의 팝업 뷰를 생성하여 enum을 통해 내부에 들어가는 내용 및 버튼 클릭에 대한 액션들을 모두 분기처리함

### Problem

- 무리한 개발 공수 산정
    - 처음부터 공수 산정 시에 어느 정도의 여유를 두고 공수를 산정했어야 했지만 길지 않은 개발 기간으로 좀 무리하게 산정을 하였더니 발생한 상황으로 무리한 공수로 인해 계속되는 공수 수정이 발생하여 너무 아쉬운 부분이였다.
- Commit 단위의 모호함
    - Commit을 컨벤션을 통일하여 최대한 작은 단위로 하려고 했으나 개발 중 에러와 같은 것이 발생하면 해당 에러를 해결하기 위해 집중하다가 commit을 기능 단위로 하지 못하고 commit의 단위가 좀 모호해지는 상황이 발생해서 아쉬운 부분이 많았다.
- enum 파일이 너무 많아짐
    - 이번 프로젝트에서는 코드를 최대한 깔끔하게 짜기 위해서 enum을 통해 raw한 값을 줄이고 중복되는 코드를 재사용할 수 있게 만드는 등 많은 활용을 했다.
    - 하지만 enum을 사용할 때마다 파일을 생성하게 되니 파일이 너무 많아져서 나중에는 내가 원하는 파일을 한눈에 찾기 어려울 정도였다.
    - 이럴때는 화면 별로 사용하는 enum을 하나의 enum 안에서 관리를 했다면 좀 더 깔끔하게 관리할 수 있지 않았을까하는 아쉬운 부분이 있었다.
- 네트워크 통신 코드의 중복
    - 네트워크 통신 시에 401 에러가 발생할 경우 토큰 재발급 코드를 실행해야 하는데 그에 대한 코드를 한 군데에서 통일하지 못해서 재발급 때마다 통신 메서드를 호출해야하기 때문에 중복되는 코드가 너무 많으므로 추후에 반드시 리팩토링 해야하는 부분이라고 생각함
    - 네트워크 통신 코드를 종류 별로 만들어서 함수로 사용하고 있지만 통신 코드 내부에서 받아오는 데이터의 DTO 타입이나 URL을 제외하고는 중복되는 부분이 많기 때문에 하나로 합쳐서 중복 코드를 좀 제거할 수 있을것 같은데 하지못한 부분이 아쉬운 부분이라고 생각합니다.
- MVVM 충분한 활용 부족
    - 앱 개발 공수 초반인 회원가입 화면 부분에서는 모두 MVVM 패턴과 Rx에서도 Input/Output 구조를 사용하여 개발하였지만 추후 개발하는 과정에서 개발 공수 기한을 맞추는 것 때문에 빠르게 개발하려고 하다 보니 자연스럽게 다시 MVC 패턴으로 개발하게 되는 상황이 발생했다. 일관성 있게 MVVM 패턴을 사용하여 끝까지 개발하지 못한 부분이 많이 아쉬운 부분이라고 생각함.

### Try

- 공수 산정 시 여유를 두자
    - 공수 산정 시에 기간에 딱 맞게 타이트하게 공수를 산정하면 중간중간 생기는 에러나 다양한 이슈로 인해 공수는 언제든 수정될 수 있기 때문에 기간에서 어느정도의 시간을 앞당긴 기간으로 공수를 산정해야겠다.
- Commit의 생활화
    - 개발을 하다보면 에러를 만나 해결하거나 너무 집중하여서 Commit을 잊게 되는 순간들이 있는데 개발하는 것 만큼이나 기록하는 것도 정말 중요하다.
    - Commit은 내가 개발 한것을 단위별로 기록할 수 있는 것이기 때문에 기능 단위 별로 정해진 컨벤션을 지켜가면서 Commit을 하는 것을 생활화 해야겠다.
- enum 파일을 합쳐보기
    - enum을 통해 raw한 값이나 중복되는 코드를 많이 처리하면서 코드를 깔끔하게 처리해 볼 수 있었다.
    - 하지만 enum을 사용할 때마다 파일을 따로 만들게 되면 너무 많은 파일이 만들어질수 있고 그러다보면 같은 enum이 중복되는 경우도 발생할 수 있기 때문에 화면 별로 사용하는 enum을 나눠서 한 파일에서 관리하게 enum을 합쳐봐야겠다.
- 네트워크 통신 코드를 합쳐보기
    - 네트워크 통신 코드를 종류 별로 다 작성하다보면 통신의 종류가 많을 경우 너무 많은 코드가 생기게 된다.
    - 통신 코드를 보면 DTO 타입이나 URL을 제외하고 중복되는 부분이 많기 때문에 Generic을 사용하여 통신 코드를 하나로 합쳐봐야겠다.
- MVVM 패턴으로 통일해보기
    - 회원가입 로직을 제외하고 MVVM 패턴이 적용되어있지 않지만 한 프로젝트에서 다양한 디자인 패턴을 사용하는 것은 코드의 일관성을 해치고 가독성을 떨어뜨린다고 생각하기 때문에 MVVM 패턴으로 모두 통일해봐야겠다.

### 느낀 점

- 프로젝트를 통해서 실제 서비스 규모의 기획, 디자인을 받아서 개발해보고 그에 맞는 개발 공수도 짜보고 Confluence를 통해 백엔드와 협업해보는 경험을 할 수 있었다. 모든 기획과 디자인, 서버가 완전히 확정된 것이 아닌 개발 중 서버의 포트 번호가 변경되기도 하고 기획이 추가되기도 하는 상황에서 개발을 진행하며 코드의 유지보수 측면이 왜 중요한지, 반복되는 코드들을 왜 줄여야 하는지 몸소 깨달을 수 있는 좋은 경험이었다.
- Service Level Project를 진행하며 코드를 깔끔하게 작성하는 것도 중요하지만 프로젝트에는 정해진 기한이 있기 때문에 공수가 정말 중요하다는 것을 깨달았다. 초반에는 코드를 깔끔하게 작성하려고 하다가 공수가 조금씩 밀려 후반에는 기능을 구현하는데 급급하게 개발을 했었던 부분이 있어서 큰 아쉬움이 남는다. 이를 통해 코드의 깔끔한 작성도 중요하지만 기한을 맞추는 것도 정말 중요하기 때문에 적절한 균형이 중요하다는 것을 깨달았다.
