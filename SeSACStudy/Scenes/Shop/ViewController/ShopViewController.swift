//
//  ShopViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/12/13.
//

import UIKit

import StoreKit

class ShopViewController: BaseViewController {
    
    //MARK: - 인앱 상품 ID 정의
    //1. 인앱 상품 ID 정의
    //상품이 여러개 일 수 있기 때문에 배열이고 겹치면 안되기 때문에 Set으로 만듦
    var productIdentifiers: Set<String> = ["com.memolease.sesac1.sprout1", "com.memolease.sesac1.sprout2", "com.memolease.sesac1.sprout3", "com.memolease.sesac1.sprout4", "com.memolease.sesac1.background1", "com.memolease.sesac1.background2", "com.memolease.sesac1.background3", "com.memolease.sesac1.background4", "com.memolease.sesac1.background5", "com.memolease.sesac1.background6", "com.memolease.sesac1.background7"]
    
    //1. 인앱 상품 정보
    //위에서 만든 인앱 상품 ID를 통해 인앱 상품 정보 배열을 만들어줌
    var productArray = Array<SKProduct>()
    
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
        
        requestProductData()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [weak self] in
            self?.configureDataSource()
        }
    }
    
    //MARK: - productIdentifiers에 정의된 상품 ID에 대한 정보 가져오기 및 사용자의 디바이스가 인앱결제가 가능한지 여부 확인
    func requestProductData() {
        if SKPaymentQueue.canMakePayments() {
            print("인앱 결제 가능")
            let request = SKProductsRequest(productIdentifiers: productIdentifiers)
            request.delegate = self
            request.start() //인앱 상품 조회
        } else {
            print("In App Purchase Not Enabled")
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
            cell.inputData(index: indexPath.item)
            cell.priceButton.tag = indexPath.item
            cell.productArr = self.productArray
        }
        
        let cellRegistration2 = UICollectionView.CellRegistration<BackgroundCollectionViewCell, SesacBackground> { cell, indexPath, itemIdentifier in
            cell.sesacBackground.image = itemIdentifier.image
            cell.nameLabel.text = itemIdentifier.name
            cell.priceButton.setAttributedTitle(NSAttributedString(string: itemIdentifier.price, attributes: [NSAttributedString.Key.font: UIFont(name: Fonts.medium, size: 12)!]), for: .normal)
            cell.descriptionLabel.text = itemIdentifier.description
            cell.inputData(index: indexPath.item)
            cell.priceButton.tag = indexPath.item
            cell.productArr = self.productArray
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

extension ShopViewController: SKProductsRequestDelegate {
    //MARK: - 인앱 상품 정보 조회, 위의 start를 통해 시작됨
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
}
