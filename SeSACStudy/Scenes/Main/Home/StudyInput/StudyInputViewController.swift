//
//  StudyInputViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class StudyInputViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    let viewModel = StudyInputViewModel()
    
    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.searchTextField.backgroundColor = GrayScale.gray1
        bar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        bar.sizeToFit()
        return bar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        return view
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = searchBar
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(end)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - 화면 클릭 시 키보드 내림
    @objc func end() {
        searchBar.resignFirstResponder()
    }
    
    override func configure() {
        [searchButton].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        searchButton.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.075)
        }
    }
    
    override func bindData() {
        //MARK: - 검색 창 편집 상태 Input Output
        let input = StudyInputViewModel.Input(upKeyboard: searchBar.rx.textDidBeginEditing, downKeyboard: searchBar.rx.textDidEndEditing)
        let output = viewModel.transform(input: input)
        
        //MARK: - 검색 창 편집 상태에 따른 버튼 변경
        output.setButton
            .withUnretained(self)
            .bind { (vc, status) in
                switch status {
                case .editingDidBegin:
                    vc.searchBar.searchTextField.inputAccessoryView = vc.accButton
                case .editingDidEnd:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

extension StudyInputViewController {    
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
    
    //    private func configureDataSource() {
    //        //MARK: - 셀 등록
    //        let cellRegistration0 = UICollectionView.CellRegistration<UserImageCollectionViewCell, dummy> { cell, indexPath, itemIdentifier in
    //            cell.cardHeader.image = itemIdentifier.profile
    //            var background = UIBackgroundConfiguration.listPlainCell()
    //            background.cornerRadius = 8
    //            background.image = Icons.sesacBack1
    //            background.backgroundInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 16)
    //            cell.backgroundConfiguration = background
    //        }
    //
    //        let cellRegistration1 = UICollectionView.CellRegistration<UserCardCollectionViewCell, dummy> { cell, indexPath, itemIdentifier in
    //            cell.userCardLabel.text = itemIdentifier.name
    //            var background = UIBackgroundConfiguration.listPlainCell()
    //            background.cornerRadius = 8
    //            background.strokeColor = GrayScale.gray2
    //            background.strokeWidth = 1
    //            background.backgroundInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
    //            cell.backgroundConfiguration = background
    //        }
    //
    //        let cellRegistration2 = UICollectionView.CellRegistration<GenderCollectionViewCell, dummy> { cell,indexPath,itemIdentifier in
    //        }
    //
    //        let cellRegistration3 = UICollectionView.CellRegistration<StudyCollectionViewCell, dummy> { cell, indexPath, itemIdentifier in
    //        }
    //
    //        let cellRegistration4 = UICollectionView.CellRegistration<SearchAllowCollectionViewCell, dummy> { cell, indexPath, itemIdentifier in
    //        }
    //
    //        let cellRegistration5 = UICollectionView.CellRegistration<AgeCollectionViewCell, dummy> { cell, indexPath, itemIdentifier in
    //        }
    //
    //        let cellRegistration6 = UICollectionView.CellRegistration<WithdrawCollectionViewCell, dummy> { cell, indexPath, itemIdentifier in
    //            cell.withdrawButton.rx.tap
    //                .bind { _ in
    //                    let vc = WithdrawViewController()
    //                    vc.modalPresentationStyle = .overFullScreen
    //                    self.present(vc, animated: true)
    //                }
    //                .disposed(by: self.disposeBag)
    //        }
    //
    //        //MARK: - 데이터 소스에 데이터 넣기
    //        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
    //            let cell0 = collectionView.dequeueConfiguredReusableCell(using: cellRegistration0, for: indexPath, item: itemIdentifier)
    //            let cell1 = collectionView.dequeueConfiguredReusableCell(using: cellRegistration1, for: indexPath, item: itemIdentifier)
    //            let cell2 = collectionView.dequeueConfiguredReusableCell(using: cellRegistration2, for: indexPath, item: itemIdentifier)
    //            let cell3 = collectionView.dequeueConfiguredReusableCell(using: cellRegistration3, for: indexPath, item: itemIdentifier)
    //            let cell4 = collectionView.dequeueConfiguredReusableCell(using: cellRegistration4, for: indexPath, item: itemIdentifier)
    //            let cell5 = collectionView.dequeueConfiguredReusableCell(using: cellRegistration5, for: indexPath, item: itemIdentifier)
    //            let cell6 = collectionView.dequeueConfiguredReusableCell(using: cellRegistration6, for: indexPath, item: itemIdentifier)
    //
    //            guard let section = Section(rawValue: indexPath.section) else { return nil }
    //
    //            switch section {
    //            case .main:
    //                return cell0
    //            case .profile:
    //                return cell1
    //            case .gender:
    //                return cell2
    //            case .study:
    //                return cell3
    //            case .search:
    //                return cell4
    //            case .age:
    //                return cell5
    //            case .withdraw:
    //                return cell6
    //            }
    //        })
    //
    //        //MARK: - 스냅샷으로 데이터를 보여주기
    //        currentSnapshot = NSDiffableDataSourceSnapshot<Section, dummy>()
    //        Section.allCases.forEach { section in
    //            currentSnapshot.appendSections([section])
    //            currentSnapshot.appendItems(dummy.contents(), toSection: section)
    //        }
    //        dataSource.apply(currentSnapshot, animatingDifferences: true)
    //    }
}

