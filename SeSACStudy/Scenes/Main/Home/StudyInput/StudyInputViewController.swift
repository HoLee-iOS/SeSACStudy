//
//  StudyInputViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/23.
//

import UIKit

import FirebaseAuth
import SnapKit
import RxSwift
import RxCocoa
import Toast

class StudyInputViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    let viewModel = StudyInputViewModel()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.searchTextField.delegate = self
        bar.searchTextField.backgroundColor = GrayScale.gray1
        bar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        bar.sizeToFit()
        return bar
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSMutableAttributedString(string: "새싹 찾기", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.regular, size: 16)!, NSAttributedString.Key.foregroundColor : BlackNWhite.white]), for: .normal)
        button.backgroundColor = BrandColor.green
        button.layer.cornerRadius = 8
        return button
    }()
    
    let accButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.06))
        button.setAttributedTitle(NSMutableAttributedString(string: "새싹 찾기", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.regular, size: 16)!, NSAttributedString.Key.foregroundColor : BlackNWhite.white]), for: .normal)
        button.backgroundColor = BrandColor.green
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        //MARK: - 스터디 입력 화면을 수직 스크롤 할 경우 키보드 내려감
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, TagList>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Int, TagList>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = searchBar
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(end)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        searchMate()
    }
    
    //MARK: - search API 통신
    func searchMate() {
        APIService.searchAround { [weak self] (value, statusCode, error) in
            guard let statusCode = statusCode else { return }
            guard let status = NetworkError(rawValue: statusCode) else { return }
            switch status {
            case .success:
                guard let value = value else { return }
                SesacList.aroundList = value.fromQueueDB
                SesacList.requestList = value.fromQueueDBRequested
                SesacList.recommendList = value.fromRecommend
                TagList.allTags.removeAll()
                TagList.redTags.removeAll()
                //MARK: - 빨간색 태그 값 가져오기
                value.fromRecommend.forEach { value in
                    TagList.redTags.append(TagList(text: value))
                    TagList.allTags.append(TagList(text: value))
                }
                //MARK: - 스터디를 찾는 다른 사용자 목록 값 요청
                value.fromQueueDB.forEach { pin in
                    //MARK: - 회색 태그 값 가져오기
                    pin.studylist.forEach { value in
                        TagList.allTags.append(TagList(text: value))
                    }
                }
                //MARK: - 예외처리를 한 태그 배열 회색 태그 배열에 담기
                TagList.grayTags.removeAll()
                let arr = Array(Set(TagList.allTags.map{ $0.text.lowercased() }.filter{ $0.count > 0 }).subtracting(TagList.redTags.map{$0.text.lowercased()}))
                arr.forEach { TagList.grayTags.append(TagList(text: $0)) }
                self?.updateUI()
                return
            case .invalidToken: self?.refreshToken2()
                return
            default: self?.showToast("잠시 후 다시 시도해주세요.")
                return
            }
        }
    }
    
    //MARK: - 토큰 만료 시 토큰 재발급
    func refreshToken2() {
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
                APIService.searchAround { [weak self] (value, status, error) in
                    guard let status = status else { return }
                    guard let networkCode = NetworkError(rawValue: status) else { return }
                    switch networkCode {
                    case .success:
                        guard let value = value else { return }
                        TagList.allTags.removeAll()
                        TagList.redTags.removeAll()
                        //MARK: - 빨간색 태그 값 가져오기
                        value.fromRecommend.forEach { value in
                            TagList.redTags.append(TagList(text: value))
                            TagList.allTags.append(TagList(text: value))
                        }
                        //MARK: - 스터디를 찾는 다른 사용자 목록 값 요청
                        value.fromQueueDB.forEach { pin in
                            //MARK: - 회색 태그 값 가져오기
                            pin.studylist.forEach { value in
                                TagList.allTags.append(TagList(text: value))
                            }
                        }
                        //MARK: - 예외처리를 한 태그 배열 회색 태그 배열에 담기
                        TagList.grayTags.removeAll()
                        let arr = Array(Set(TagList.allTags.map{ $0.text.lowercased() }.filter{ $0.count > 0 }).subtracting(TagList.redTags.map{$0.text.lowercased()}))
                        arr.forEach { TagList.grayTags.append(TagList(text: $0)) }
                        self?.updateUI()
                        return
                    default: self?.showToast("잠시 후 다시 시도해 주세요.")
                        return
                    }
                }
            }
        }
    }
    
    //MARK: - 화면 클릭 시 키보드 내림
    @objc func end() {
        searchBar.resignFirstResponder()
    }
    
    override func configure() {
        configureDataSource()
        [searchButton, collectionView].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        searchButton.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.075)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.bottom.equalTo(searchButton.snp.top)
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
                APIService.sesacSearch { [weak self] (value, statusCode, error) in
                    guard let statusCode = statusCode else { return }
                    guard let status = NetworkError(rawValue: statusCode) else { return }
                    switch status {
                    case .success:
                        self?.view.makeToast("스터디 함께할 친구 찾기 요청 성공", position: .center) { _ in
                            let viewController = SesacSearchTabViewController()
                            self?.navigationController?.pushViewController(viewController, animated: true)
                        }
                    case .alreadySignUp: self?.showToast("신고가 누적되어 이용하실 수 없습니다")
                    case .alreadyMatched: self?.showToast("스터디 취소 패널티로, 1분동안 이용하실 수 없습니다")
                    case .penalty2: self?.showToast("스터디 취소 패널티로, 2분동안 이용하실 수 없습니다")
                    case .penalty3: self?.showToast("스터디 취소 패널티로, 3분동안 이용하실 수 없습니다")
                    default: self?.showToast("잠시 후 다시 시도해주세요.")
                    }
                }
            }
        }
    }
    
    override func bindData() {
        //MARK: - 새싹 찾기 버튼 클릭에 대한 기능
        searchButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                UserDefaultsManager.studyList.removeAll()
                TagList.greenTags.forEach { UserDefaultsManager.studyList.append($0.text) }
                APIService.sesacSearch { value, statusCode, error in
                    guard let statusCode = statusCode else { return }
                    guard let status = NetworkError(rawValue: statusCode) else { return }
                    switch status {
                    case .success:
                        let viewController = SesacSearchTabViewController()
                        vc.navigationController?.pushViewController(viewController, animated: true)
                    case .alreadySignUp: vc.showToast("신고가 누적되어 이용하실 수 없습니다")
                    case .alreadyMatched: vc.showToast("스터디 취소 패널티로, 1분동안 이용하실 수 없습니다")
                    case .penalty2: vc.showToast("스터디 취소 패널티로, 2분동안 이용하실 수 없습니다")
                    case .penalty3: vc.showToast("스터디 취소 패널티로, 3분동안 이용하실 수 없습니다")
                    case .invalidToken: vc.refreshToken1()
                    default: vc.showToast("\(statusCode): 잠시 후 다시 시도해주세요.")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        //MARK: - 검색 창 편집 상태 Input Output
        let input = StudyInputViewModel.Input(upKeyboard: searchBar.rx.textDidBeginEditing, downKeyboard: searchBar.rx.textDidEndEditing)
        let output = viewModel.transform(input: input)
        
        //MARK: - 검색 창 편집 상태에 따른 버튼 변경
        output.setButton
            .withUnretained(self)
            .bind { (vc, status) in
                switch status {
                case .editingDidBegin:
                    vc.searchButton.isHidden = true
                    vc.searchBar.searchTextField.inputAccessoryView = vc.accButton
                case .editingDidEnd:
                    vc.searchButton.isHidden = false
                    vc.searchBar.searchTextField.text = nil
                }
            }
            .disposed(by: disposeBag)
    }
}

extension StudyInputViewController: UITextFieldDelegate {
    //MARK: - 키보드 리턴 버튼 클릭 시 추가
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if TagList.greenTags.count == 8 {
            showToast("스터디를 더 이상 추가할 수 없습니다.")
            return true
        }
        
        if (textField.text == "") || (textField.text == " ") {
            showToast("스터디명은 최소 한 자 이상, 최대 8글자까지 작성 가능합니다.")
            return true
        }
        
        guard let text = textField.text else { return true }
        var inputStudy = text.components(separatedBy: " ").filter { $0.count > 0 }
        let inputStudyLength = inputStudy.map { $0.count }.filter { $0 != 0 }
        
        if inputStudyLength.min() ?? 0 < 1 || inputStudyLength.max() ?? 0 > 8  {
            showToast("스터디명은 최소 한 자 이상, 최대 8글자까지 작성 가능합니다.")
            return true
        } else if (inputStudy.count + TagList.greenTags.count) > 8 {
            showToast("내가 하고 싶은 스터디는 8개까지만 등록이 가능합니다.")
            return true
        } else {
            //MARK: 중복된 스터디 추가 제한
            inputStudy.forEach{ value in
                let tag = TagList.greenTags.map{ $0.text.lowercased() }
                if tag.contains(value.lowercased()) {
                    showToast("이미 등록된 스터디입니다.")
                } else {
                    TagList.greenTags.append(TagList(text: value))
                }
            }
            textField.resignFirstResponder()
            inputStudy.removeAll()
            updateUI()
            return true
        }
    }
}


extension StudyInputViewController {    
    //MARK: - compositionalLayout 설정
    private func createLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { (sectionIndex: Int,
                                 layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(44), heightDimension: .estimated(44))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0)
            
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: StudyInputCollectionReusableView.reuseIdentifier,
                alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
            
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    private func configureDataSource() {        
        //MARK: - cell 등록
        let cellRegistration = UICollectionView.CellRegistration<StudyInputCollectionViewCell, TagList> { (cell, indexPath, item) in
            
            cell.setCell(text: item.text, indexPath: indexPath)
            
            //MARK: - 태그 버튼 클릭 시 내가 하고 싶은 스터디 추가
            cell.tagButton.rx.tap
                .withUnretained(self)
                .bind { (vc, _) in
                    if indexPath.section == 0 {
                        //MARK: - 하고 싶은 스터디 개수 제한
                        if TagList.greenTags.count == 8 {
                            vc.showToast("스터디를 더 이상 추가할 수 없습니다.")
                            return
                        }
                        //MARK: 중복된 스터디 추가 제한
                        let tag = TagList.greenTags.map{$0.text.lowercased()}
                        if tag.contains(item.text.lowercased()) {
                            vc.showToast("이미 등록된 스터디입니다.")
                            return
                        }
                        TagList.greenTags.append(TagList(text: item.text))
                    } else {
                        TagList.greenTags.removeAll { value in
                            value.text == item.text
                        }
                    }
                    vc.updateUI()
                }
                .disposed(by: self.disposeBag)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, TagList>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<StudyInputCollectionReusableView>(elementKind: StudyInputCollectionReusableView.reuseIdentifier) {
            supplementaryView, elementKind, indexPath in
            supplementaryView.setSection(indexPath: indexPath)
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
    }
    
    //MARK: - 값 변경에 따른 컬렉션 뷰 업데이트
    func updateUI() {
        currentSnapshot = NSDiffableDataSourceSnapshot<Int, TagList>()
        currentSnapshot.appendSections([0, 1])
        
        currentSnapshot.appendItems(TagList.redTags, toSection: 0)
        currentSnapshot.appendItems(TagList.grayTags, toSection: 0)
        currentSnapshot.appendItems(TagList.greenTags, toSection: 1)
        
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
}

