//
//  MapViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/22.
//

import UIKit
import MapKit
import CoreLocation
import SnapKit

class MapViewController: BaseViewController {
    
    let mapView = MKMapView()
    
    let floatingButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func configure() {
        [mapView].forEach{ view.addSubview($0) }
    }
    
    override func setConstraints() {
        mapView.snp.makeConstraints {
            $0.top.equalTo(view)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
