//
//  UserCardTableViewCell.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/15.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class UserCardCollectionViewCell: BaseCollectionViewCell {
    
    let userCardLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let subImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override var isSelected: Bool {
        didSet {
            print(isSelected)
            if isSelected {
                closeCon()
            }  else {
                showCon()
            }
        }
    }
    
    override func configure() {
        [userCardLabel, subImage].forEach{ contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        userCardLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.3)
        }
        
        subImage.snp.makeConstraints { make in
            make.top.equalTo(userCardLabel.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    func showCon() {
        userCardLabel.snp.remakeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.3)
        }
        subImage.snp.remakeConstraints { make in
            make.top.equalTo(userCardLabel.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    func closeCon() {
        userCardLabel.snp.remakeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.3)
        }
    }
    
//    func show(completion: @escaping () -> Void = {}) {
//        greenView.snp.makeConstraints { make in
//            make.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
//            make.trailing.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
//            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.3)
//        }
//
//        userCardLabel.snp.remakeConstraints{ make in
//            make.bottom.equalTo(greenView.snp.top).offset(-20)
//            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-20)
//            make.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
//            make.height.equalTo(44)
//        }
//
//        UIView.animate(
//            withDuration: 0.3,
//            delay: 0,
//            options: .curveEaseInOut,
//            animations: { self.layoutIfNeeded() },
//            completion: { _ in completion() }
//        )
//    }
    

//    func openConstraints() {
//        greenView.isHidden = true
//        userCardLabel.snp.remakeConstraints{ make in
//            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
//            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-20)
//            make.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
//            make.height.width.equalTo(44)
//        }
//        UIView.animate(
//            withDuration: 0.3,
//            delay: 0,
//            options: .curveEaseInOut,
//            animations: { self.layoutIfNeeded() }
//        )
//    }
}
