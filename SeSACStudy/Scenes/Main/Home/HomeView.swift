//
//  HomeView.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/22.
//

import UIKit
import MapKit
import SnapKit

class HomeView: BaseView {
    
    let mapView = MKMapView()
    
    let centerPin: UIImageView = {
        let image = UIImageView()
        image.image = Icons.mapMarker
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let floatingButton: UIButton = {
        let button = UIButton()
        button.setImage(Icons.floatingSearch, for: .normal)
        button.backgroundColor = BlackNWhite.black
        button.tintColor = BlackNWhite.white
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    let allButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init("전체")
        titleAttr.font = UIFont(name: Fonts.regular, size: 14)
        titleAttr.foregroundColor = BlackNWhite.white
        config.attributedTitle = titleAttr
        button.configuration = config
        button.backgroundColor = BrandColor.green
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        button.layer.cornerRadius = 8
        button.addShadow(location: .top)
        button.addShadow(location: .left)
        button.addShadow(location: .right)
        return button
    }()
    
    let maleButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init("남자")
        titleAttr.font = UIFont(name: Fonts.regular, size: 14)
        titleAttr.foregroundColor = BlackNWhite.black
        config.attributedTitle = titleAttr
        button.configuration = config
        button.backgroundColor = BlackNWhite.white
        button.addShadow(location: .left)
        button.addShadow(location: .right)
        return button
    }()
    
    let femaleButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init("여자")
        titleAttr.font = UIFont(name: Fonts.regular, size: 14)
        titleAttr.foregroundColor = BlackNWhite.black
        config.attributedTitle = titleAttr
        button.configuration = config
        button.backgroundColor = BlackNWhite.white
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        button.layer.cornerRadius = 8
        button.addShadow(location: .bottom)
        button.addShadow(location: .left)
        button.addShadow(location: .right)
        return button
    }()
    
    let locationButton: UIButton = {
        let button = UIButton()
        button.setImage(Icons.myLocation, for: .normal)
        button.backgroundColor = BlackNWhite.white
        button.layer.cornerRadius = 8
        button.addShadow(location: .bottom)
        button.addShadow(location: .left)
        button.addShadow(location: .right)
        return button
    }()
    
    override func configure() {        
        [mapView, centerPin, floatingButton, allButton, maleButton, femaleButton, locationButton].forEach{ self.addSubview($0) }
    }
    
    override func setConstraints() {
        mapView.snp.makeConstraints {
            $0.top.equalTo(self)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        centerPin.snp.makeConstraints {
            $0.center.equalTo(mapView)
            $0.width.equalTo(safeAreaLayoutGuide).multipliedBy(0.1)
            $0.height.equalTo(centerPin.snp.width)
        }
        
        floatingButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            $0.width.equalTo(safeAreaLayoutGuide).multipliedBy(0.15)
            $0.height.equalTo(floatingButton.snp.width)
        }
        
        allButton.snp.makeConstraints {
            $0.top.leading.equalTo(safeAreaLayoutGuide).inset(16)
            $0.width.equalTo(safeAreaLayoutGuide).multipliedBy(0.13)
            $0.height.equalTo(allButton.snp.width)
        }
        
        maleButton.snp.makeConstraints {
            $0.top.equalTo(allButton.snp.bottom)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(16)
            $0.width.height.equalTo(allButton.snp.width)
        }
        
        femaleButton.snp.makeConstraints {
            $0.top.equalTo(maleButton.snp.bottom)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(16)
            $0.width.height.equalTo(allButton.snp.width)
        }
        
        locationButton.snp.makeConstraints {
            $0.top.equalTo(femaleButton.snp.bottom).offset(16)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(16)
            $0.width.height.equalTo(allButton.snp.width)
        }
    }
    
    override func layoutSubviews() {
        floatingButton.layer.cornerRadius = floatingButton.bounds.height / 2
    }
}
