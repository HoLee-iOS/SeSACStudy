//
//  HomeViewController.swift
//  SeSACStudy
//
//  Created by 이현호 on 2022/11/22.
//

import UIKit
import MapKit
import CoreLocation
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    lazy var locationManager: CLLocationManager = {
        let loc = CLLocationManager()
        loc.distanceFilter = 10000
        loc.desiredAccuracy = kCLLocationAccuracyBest
        loc.requestWhenInUseAuthorization()
        loc.delegate = self
        return loc
    }()
    
    let homeView = HomeView()
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkUserDeviceLocationServiceAuthorization()
        
        setRegionAndAnnotation(center: CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270))
        limitZoomRange()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - 위경도 기준으로 보여질 범위 설정
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 350, longitudinalMeters: 350)
        homeView.mapView.setRegion(region, animated: true)
    }
    
    //MARK: - 카메라 줌 범위 설정
    func limitZoomRange() {
        let zoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 50, maxCenterCoordinateDistance: 3000)
        homeView.mapView.setCameraZoomRange(zoomRange, animated: true)
    }
    
    override func bindData() {
        //MARK: - GPS 버튼 구현
        homeView.locationButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                guard let loc = vc.locationManager.location?.coordinate else {
                    vc.checkUserDeviceLocationServiceAuthorization()
                    return
                }
                vc.setRegionAndAnnotation(center: loc)
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    //MARK: - 권한 요청
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        authorizationStatus = locationManager.authorizationStatus
        
        checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    //MARK: - 권한 체크
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            //앱을 사용하는 동안에 권한에 대한 위치 권한 요청
            locationManager.requestWhenInUseAuthorization()
        case .restricted ,.denied:
            print("DENIED")
            showRequestLocationServiceAlert()
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            //사용자가 위치를 허용해둔 상태라면, startUpdatingLocation을 통해 didUpdateLocations 메서드가 실행
            locationManager.startUpdatingLocation() //단점: 정확도를 위해서 무한대로 호출됨
        default: print("디폴트")
        }
    }
    
    //MARK: - 권한 거부시 경고창
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            //설정까지 이동하거나 설정 세부화면까지 이동하거나
            //한 번도 설정 앱에 들어가지 않았거나, 막 다운받은 앱이거나 - 설정
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default) { [weak self] _ in
            self?.setRegionAndAnnotation(center: CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270))
        }
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    //MARK: - 앱 실행시 제일 처음 실행
    //MARK: - 사용자의 위치 권한 상태가 바뀔때 알려줌
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
    //MARK: - 위치를 성공적으로 가지고 온 경우 실행
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last?.coordinate else { return }
        setRegionAndAnnotation(center: loc)
        locationManager.stopUpdatingLocation()
    }
    
    //MARK: - 위치 가져오지 못한 경우 실행(권한 거부시)
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showRequestLocationServiceAlert()
    }
}
