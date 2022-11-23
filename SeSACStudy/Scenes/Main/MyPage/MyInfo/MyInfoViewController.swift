//
//  MyInfoViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import FirebaseAuth

class MyInfoViewController: BaseViewController {
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        return view
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, dummy>!
    
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, dummy>!
    
    let disposeBag = DisposeBag()
    
    let viewModel = MyInfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.title = "정보 관리"
        
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: - 저장 버튼 클릭 시 PUT 통신을 통해 회원 정보 수정
    @objc func saveButtonTapped() {
        APIService.myPage { [weak self] (value, statusCode, error) in
            guard let statusCode = statusCode else { return }
            guard let networkErr = NetworkError(rawValue: statusCode) else { return }
            switch networkErr {
            case .success:
                self?.view.makeToast("저장 성공", position: .center, completion: { _ in
                    self?.navigationController?.popViewController(animated: true)
                })
            case .invalidToken: self?.refreshToken()
            default: self?.showToast("잠시 후 다시 시도해 주세요.")
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
                APIService.myPage { [weak self] (value, status, error) in
                    guard let status = status else { return }
                    guard let networkCode = NetworkError(rawValue: status) else { return }
                    switch networkCode {
                    case .success:
                        self?.view.makeToast("저장 성공", position: .center, completion: { _ in
                        self?.navigationController?.popViewController(animated: true)
                    })
                    default: self?.showToast("잠시 후 다시 시도해 주세요.")
                    }
                }
            }
        }
    }
    
    override func configure() {
        view.addSubview(collectionView)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension MyInfoViewController {
    
    //MARK: - compositionalLayout 설정
    private func createLayout() -> UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: sectionNumber) else { return nil }
            switch section {
            case .main:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalWidth(0.6))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
            case .profile:
                let estimatedHeight = CGFloat(70)
                let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .estimated(estimatedHeight))
                let item = NSCollectionLayoutItem(layoutSize: layoutSize)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                return section
            case .gender, .study, .search, .age, .withdraw:
                let estimatedHeight = CGFloat(90)
                let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .estimated(estimatedHeight))
                let item = NSCollectionLayoutItem(layoutSize: layoutSize)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        }
    }
    
    private func configureDataSource() {
        //MARK: - 셀 등록
        let cellRegistration0 = UICollectionView.CellRegistration<UserImageCollectionViewCell, dummy> { cell, indexPath, itemIdentifier in
            cell.cardHeader.image = itemIdentifier.profile
            var background = UIBackgroundConfiguration.listPlainCell()
            background.cornerRadius = 8
            background.image = Icons.sesacBack1
            background.backgroundInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 16)
            cell.backgroundConfiguration = background
        }
        
        let cellRegistration1 = UICollectionView.CellRegistration<UserCardCollectionViewCell, dummy> { cell, indexPath, itemIdentifier in
            cell.userCardLabel.text = itemIdentifier.name
            var background = UIBackgroundConfiguration.listPlainCell()
            background.cornerRadius = 8
            background.strokeColor = GrayScale.gray2
            background.strokeWidth = 1
            background.backgroundInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
            cell.backgroundConfiguration = background
        }
        
        let cellRegistration2 = UICollectionView.CellRegistration<GenderCollectionViewCell, dummy> { cell,indexPath,itemIdentifier in
        }
        
        let cellRegistration3 = UICollectionView.CellRegistration<StudyCollectionViewCell, dummy> { cell, indexPath, itemIdentifier in
        }
        
        let cellRegistration4 = UICollectionView.CellRegistration<SearchAllowCollectionViewCell, dummy> { cell, indexPath, itemIdentifier in
        }
        
        let cellRegistration5 = UICollectionView.CellRegistration<AgeCollectionViewCell, dummy> { cell, indexPath, itemIdentifier in
        }
        
        let cellRegistration6 = UICollectionView.CellRegistration<WithdrawCollectionViewCell, dummy> { cell, indexPath, itemIdentifier in
            cell.withdrawButton.rx.tap
                .bind { _ in
                    let vc = WithdrawViewController()
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true)
                }
                .disposed(by: self.disposeBag)
        }
        
        //MARK: - 데이터 소스에 데이터 넣기
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell0 = collectionView.dequeueConfiguredReusableCell(using: cellRegistration0, for: indexPath, item: itemIdentifier)
            let cell1 = collectionView.dequeueConfiguredReusableCell(using: cellRegistration1, for: indexPath, item: itemIdentifier)
            let cell2 = collectionView.dequeueConfiguredReusableCell(using: cellRegistration2, for: indexPath, item: itemIdentifier)
            let cell3 = collectionView.dequeueConfiguredReusableCell(using: cellRegistration3, for: indexPath, item: itemIdentifier)
            let cell4 = collectionView.dequeueConfiguredReusableCell(using: cellRegistration4, for: indexPath, item: itemIdentifier)
            let cell5 = collectionView.dequeueConfiguredReusableCell(using: cellRegistration5, for: indexPath, item: itemIdentifier)
            let cell6 = collectionView.dequeueConfiguredReusableCell(using: cellRegistration6, for: indexPath, item: itemIdentifier)
            
            guard let section = Section(rawValue: indexPath.section) else { return nil }
            
            switch section {
            case .main:
                return cell0
            case .profile:
                return cell1
            case .gender:
                return cell2
            case .study:
                return cell3
            case .search:
                return cell4
            case .age:
                return cell5
            case .withdraw:
                return cell6
            }
        })
        
        //MARK: - 스냅샷으로 데이터를 보여주기
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, dummy>()
        Section.allCases.forEach { section in
            currentSnapshot.appendSections([section])
            currentSnapshot.appendItems(dummy.contents(), toSection: section)
        }
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
}

//MARK: - UI 업데이트
//    func updateUI() {
//        currentSnapshot = NSDiffableDataSourceSnapshot<Section, dummy>()
//        currentSnapshot.appendSections([.main])
//        currentSnapshot.appendItems(dummy.contents(), toSection: .main)
//
//
//        if hiddenPLZ {
//            currentSnapshot.appendSections([.profile])
//            currentSnapshot.appendItems([dummy(profile: nil, name: "에이치호")], toSection: .profile)
//        } else {
//            currentSnapshot.appendSections([.profile])
//            currentSnapshot.appendItems(dummy.contents(), toSection: .profile)
//        }
//
//        dataSource.apply(currentSnapshot, animatingDifferences: true)
////        currentSnapshot = NSDiffableDataSourceSnapshot<Section, dummy>()
////        Section.allCases.forEach { section in
////            currentSnapshot.appendSections([section])
////            currentSnapshot.appendItems(dummy.contents(), toSection: section)
////        }
////        dataSource.apply(currentSnapshot, animatingDifferences: true)
//    }
