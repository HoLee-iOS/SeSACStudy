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
    
    func setConstraints() {
        
        [cardBackground, cardHeader, requestButton].forEach{ addSubview($0) }
        
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
        
        cardBackground.image = SesacBackground(rawValue: arr[requestButton.tag].background)?.image
        cardHeader.image = SesacFace(rawValue: arr[requestButton.tag].sesac)?.image        
    }
}
