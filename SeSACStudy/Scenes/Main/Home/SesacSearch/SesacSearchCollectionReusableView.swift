//
//  SesacSearchCollectionReusableView.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/26.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class SesacSearchCollectionReusableView: UICollectionReusableView {
    
    let disposeBag = DisposeBag()
    
    lazy var cardBackground: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()
    
    lazy var cardHeader: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 8
        return image
    }()
    
    let requestButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        button.layer.cornerRadius = 8
        config.contentInsets = .init(top: 9, leading: 14, bottom: 9, trailing: 14)
        button.configuration = config
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func prepareForReuse() {
//        cardBackground.image = nil
//        cardHeader.image = nil
//    }
    
    func setConstraints() {
        
        [cardBackground, cardHeader, requestButton].forEach{ self.addSubview($0) }
        
        cardBackground.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        cardHeader.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(safeAreaLayoutGuide)
            $0.centerY.equalTo(safeAreaLayoutGuide).multipliedBy(1.1)
        }
        
        requestButton.snp.makeConstraints {
            $0.top.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(cardHeader.safeAreaLayoutGuide).multipliedBy(0.15)
            $0.width.equalTo(requestButton.snp.height).multipliedBy(2)
        }
    }
    
    //MARK: - 섹션마다 값 넣기
    func setSection(page: Int, indexPath: IndexPath) {
        
        let arr = page == 0 ? SesacList.aroundList : SesacList.requestList
        
        requestButton.tag = indexPath.section
        requestButton.configuration?.attributedTitle = page == 0 ? "요청하기" : "수락하기"
        requestButton.configuration?.attributedTitle?.font = UIFont(name: Fonts.medium, size: 14)
        requestButton.configuration?.attributedTitle?.foregroundColor = BlackNWhite.white
        requestButton.backgroundColor = page == 0 ? SystemColor.error : SystemColor.success
        
        switch SesacBackground(rawValue: arr[requestButton.tag].background) {
        case .back1: cardBackground.image = SesacBackground.back1.images
        case .back2: cardBackground.image = SesacBackground.back2.images
        case .back3: cardBackground.image = SesacBackground.back3.images
        case .back4: cardBackground.image = SesacBackground.back4.images
        case .back5: cardBackground.image = SesacBackground.back5.images
        case .back6: cardBackground.image = SesacBackground.back6.images
        case .back7: cardBackground.image = SesacBackground.back7.images
        case .back8: cardBackground.image = SesacBackground.back8.images
        case .back9: cardBackground.image = SesacBackground.back9.images
        default: break
        }
        
        switch SesacFace(rawValue: arr[requestButton.tag].sesac) {
        case .face1: cardHeader.image = SesacFace.face1.images
        case .face2: cardHeader.image = SesacFace.face2.images
        case .face3: cardHeader.image = SesacFace.face3.images
        case .face4: cardHeader.image = SesacFace.face4.images
        case .face5: cardHeader.image = SesacFace.face5.images
        default: break
        }
    }
}
