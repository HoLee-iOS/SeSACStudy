//
//  StudyInputCollectionReusableView.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/24.
//

import UIKit

import SnapKit

final class SearchCollectionReusableView: UICollectionReusableView {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.regular, size: 12)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide).inset(8)
        }
    }
    
//    func setComponents(text: String?) {
//        headerLabel.text = text
//    }
}
