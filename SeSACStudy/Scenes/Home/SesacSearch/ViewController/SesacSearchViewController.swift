//
//  SesacSearchViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/25.
//

import UIKit

import FirebaseAuth
import RxSwift
import RxCocoa
import Tabman

final class SesacSearchViewController: BaseViewController {
    
    private struct Item: Hashable {
        let uid: String?
        let sesac: Int?
        let background: Int?
        let nick: String?
        private let identifier = UUID()
    }
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        return view
    }()
    
    private let emptyView: EmptyView = {
        let view = EmptyView()
        return view
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<FromQueueDB, Item>!
    
    private var currentSnapshot: NSDiffableDataSourceSnapshot<FromQueueDB, Item>!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //MARK: - 화면 진입 시 주변 새싹 검색 통신
        searchMate()
    }
    
    override func configure() {
        switchEmptyView()
        configureDataSource()
        [collectionView, emptyView].forEach{ view.addSubview($0) }
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func bindData() {
        //MARK: - 스터디 변경하기 버튼 클릭 시 스터디 입력 화면으로 전환
        emptyView.changeButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        //MARK: - 새로고침 버튼 클릭 시 새싹 목록 갱신
        emptyView.refreshButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.searchMate()
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - 배열 값에 따라 빈 화면으로 보여주기
    func switchEmptyView() {
        switch pageboyPageIndex {
        case 0:
            SesacList.aroundList.isEmpty ? (emptyView.isHidden = false) : (emptyView.isHidden = true)
            emptyView.mainLabel.text = "아쉽게도 주변에 새싹이 없어요ㅠ"
        case 1:
            SesacList.requestList.isEmpty ? (emptyView.isHidden = false) : (emptyView.isHidden = true)
            emptyView.mainLabel.text = "아직 받은 요청이 없어요ㅠ"
        default:
            break
        }
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
                self?.switchEmptyView()
                self?.updateUI()
                return
            case .invalidToken: self?.refreshToken()
                return
            default: self?.showToast("잠시 후 다시 시도해주세요.")
                return
            }
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
                APIService.searchAround { [weak self] (value, status, error) in
                    guard let status = status else { return }
                    guard let networkCode = NetworkError(rawValue: status) else { return }
                    switch networkCode {
                    case .success:
                        guard let value = value else { return }
                        SesacList.aroundList = value.fromQueueDB
                        SesacList.requestList = value.fromQueueDBRequested
                        SesacList.recommendList = value.fromRecommend
                        self?.updateUI()
                        return
                    default: self?.showToast("잠시 후 다시 시도해 주세요.")
                        return
                    }
                }
            }
        }
    }
}

extension SesacSearchViewController {
    
    //MARK: - compositionalLayout 설정
    private func createLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let estimatedHeight = CGFloat(70)
            let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(estimatedHeight))
            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
            
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: SesacSearchCollectionReusableView.reuseIdentifier,
                alignment: .top)
            
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    private func configureDataSource() {
        //MARK: - 셀 등록
        let cellRegistration = UICollectionView.CellRegistration<UserCardCollectionViewCell, Item> { cell, indexPath, itemIdentifier in
            cell.userCardLabel.text = itemIdentifier.nick
            var background = UIBackgroundConfiguration.listPlainCell()
            background.cornerRadius = 8
            background.strokeColor = GrayScale.gray2
            background.strokeWidth = 1
            cell.backgroundConfiguration = background
        }
        
        //MARK: - 데이터 소스에 데이터 넣기
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        //MARK: - 헤더뷰 등록
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<SesacSearchCollectionReusableView>(elementKind: SesacSearchCollectionReusableView.reuseIdentifier) {
            supplementaryView, elementKind, indexPath in
            
            supplementaryView.setSection(page: self.pageboyPageIndex ?? 0, indexPath: indexPath)
            
            supplementaryView.requestButton.rx.tap
                .bind { _ in
                    UserDefaultsManager.otheruid = self.pageboyPageIndex == 0 ? SesacList.aroundList[supplementaryView.requestButton.tag].uid : SesacList.requestList[supplementaryView.requestButton.tag].uid
                    let vc = RequestViewController()
                    vc.modalPresentationStyle = .overFullScreen
                    vc.pageIndex = self.pageboyPageIndex ?? 0
                    vc.setAlertView(page: self.pageboyPageIndex ?? 0)
                    self.present(vc, animated: true)
                }
                .disposed(by: self.disposeBag)
        }
        
        //MARK: - 데이터 소스에 헤더 데이터 넣기
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
    }
    
    func updateUI() {
        //MARK: - 스냅샷으로 데이터를 보여주기
        //1. 스냅샷 객체 만들기
        currentSnapshot = NSDiffableDataSourceSnapshot<FromQueueDB, Item>()
        //2. 컬렉션뷰에 들어갈 섹션 배열 만들어주기
        let sections = pageboyPageIndex == 0 ? SesacList.aroundList : SesacList.requestList
        //3. 스냅샷에 섹션 추가해주기
        currentSnapshot.appendSections(sections)
        //4. 각 섹션마다 값 넣어주기
        for section in sections {
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
            //5. 헤더부분에 값 넣어주기
            let headerItem = Item(uid: section.uid, sesac: section.sesac, background: section.background, nick: section.nick)
            sectionSnapshot.append([headerItem])
            //6. 추가할 아이템이 있다면 값 넣기
            //let items = Item(sesac: nil, background: nil, nick: SesacList.aroundList[section].nick)
            //sectionSnapshot.append([items], to: headerItem)
            //sectionSnapshot.expand([headerItem])
            //7. 해당 섹션에 스냅샷 객체 적용
            dataSource.apply(sectionSnapshot, to: section)
        }
    }
}

