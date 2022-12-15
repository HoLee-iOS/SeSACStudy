//
//  ShopViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/13.
//

import UIKit

import FirebaseAuth

class ShopViewController: BaseViewController {
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.delegate = self
        return view
    }()
    
    private var dataSource1: UICollectionViewDiffableDataSource<Int, SesacFace>!
    private var dataSource2: UICollectionViewDiffableDataSource<Int, SesacBackground>!
    
    var snapshot1: NSDiffableDataSourceSnapshot<Int, SesacFace>!
    var snapshot2: NSDiffableDataSourceSnapshot<Int, SesacBackground>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMyInfo()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [weak self] in
            self?.configureDataSource()
        }
    }
    
    //MARK: - 내 정보 불러오기
    func loadMyInfo() {
        APIService.requestMyInfo { [weak self] (value, statusCode, error) in
            guard let statusCode = statusCode else { return }
            guard let status = NetworkError(rawValue: statusCode) else { return }
            switch status {
            case .success: break
            case .invalidToken: self?.refreshToken()
            default: self?.view.makeToast("잠시 후 다시 시도해 주세요.")
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
                APIService.requestMyInfo { [weak self] (value, statusCode, error) in
                    guard let statusCode = statusCode else { return }
                    guard let status = NetworkError(rawValue: statusCode) else { return }
                    switch status {
                    case .success: break
                    default: self?.view.makeToast("잠시 후 다시 시도해 주세요.")
                    }
                }
            }
        }
    }
    
    override func configure() {
        view.addSubview(collectionView)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(316)
        }
    }
}

extension ShopViewController {
    //MARK: - compositionalLayout 설정
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(pageboyPageIndex == 0 ? 320 : 200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: pageboyPageIndex == 0 ? 2 : 1)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureDataSource() {
        //MARK: - 셀 등록
        let cellRegistration1 = UICollectionView.CellRegistration<SesacCollectionViewCell, SesacFace> { cell, indexPath, itemIdentifier in
            cell.sesacFace.image = itemIdentifier.image
            cell.nameLabel.text = itemIdentifier.name
            cell.priceButton.setAttributedTitle(NSAttributedString(string: itemIdentifier.price, attributes: [NSAttributedString.Key.font: UIFont(name: Fonts.medium, size: 12)!]), for: .normal)
            cell.descriptionLabel.text = itemIdentifier.description
            cell.index = indexPath.item
            cell.inputData(index: indexPath.item)
        }
        
        let cellRegistration2 = UICollectionView.CellRegistration<BackgroundCollectionViewCell, SesacBackground> { cell, indexPath, itemIdentifier in
            cell.sesacBackground.image = itemIdentifier.image
            cell.nameLabel.text = itemIdentifier.name
            cell.priceButton.setAttributedTitle(NSAttributedString(string: itemIdentifier.price, attributes: [NSAttributedString.Key.font: UIFont(name: Fonts.medium, size: 12)!]), for: .normal)
            cell.descriptionLabel.text = itemIdentifier.description
            cell.index = indexPath.item
            cell.inputData(index: indexPath.item)
        }
        
        //MARK: - 데이터 소스에 데이터 넣기, 스냅샷으로 데이터를 보여주기
        if pageboyPageIndex == 0 {
            dataSource1 = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration1, for: indexPath, item: itemIdentifier)
            })
            snapshot1 = NSDiffableDataSourceSnapshot<Int, SesacFace>()
            snapshot1.appendSections([0])
            snapshot1.appendItems(SesacFace.allCases)
            dataSource1.apply(snapshot1, animatingDifferences: true)
        } else {
            dataSource2 = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration2, for: indexPath, item: itemIdentifier)
            })
            snapshot2 = NSDiffableDataSourceSnapshot<Int, SesacBackground>()
            snapshot2.appendSections([0])
            snapshot2.appendItems(SesacBackground.allCases)
            dataSource2.apply(snapshot2, animatingDifferences: true)
        }
    }
}

extension ShopViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        pageboyPageIndex == 0 ? (ShopDataModel.shared.sesac = indexPath.item) : (ShopDataModel.shared.background = indexPath.item)
        NotificationCenter.default.post(name: Notification.Name("data"), object: indexPath.item)
    }
}
