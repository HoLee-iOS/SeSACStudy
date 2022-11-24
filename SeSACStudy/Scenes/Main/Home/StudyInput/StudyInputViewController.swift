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

final class StudyInputViewController: BaseViewController {
    
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

extension StudyInputViewController: UITextFieldDelegate {
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
            inputStudy.forEach{TagList.greenTags.append(TagList(text: $0))}
            textField.resignFirstResponder()
            inputStudy.removeAll()
            textField.text = nil
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
    
    //MARK: - dataSource 생성
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<StudyInputCollectionViewCell, TagList> { (cell, indexPath, item) in
            cell.setCell(text: item.text, indexPath: indexPath)
            
            cell.tagButton.rx.tap
                .withUnretained(self)
                .bind { (vc, _) in
                    if indexPath.section == 0 {
                        if TagList.greenTags.count == 8 {
                            vc.showToast("스터디를 더 이상 추가할 수 없습니다.")
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
        
        updateUI()
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

