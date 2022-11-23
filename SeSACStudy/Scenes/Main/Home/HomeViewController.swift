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
import FirebaseAuth

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
    
    let viewModel = HomeViewModel()
    
    var limit = false
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeView.mapView.delegate = self
        
        checkUserDeviceLocationServiceAuthorization()
        
        setRegionAndAnnotation(center: CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270))
        limitZoomRange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        //MARK: - 다른 화면에서 홈 화면으로 전환되었을 때 search
        searchMate()
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
    
    //MARK: - 어노테이션 찍기
    func addPin(type: Int, lat: Double, long: Double, gender: Int) {
        let pin = AnnotationType(type, gender: gender)
        pin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        if homeView.femaleButton.backgroundColor == BrandColor.green {
            if pin.gender == 0 {
                homeView.mapView.addAnnotation(pin)
            }
        } else if homeView.maleButton.backgroundColor == BrandColor.green {
            if pin.gender == 1 {
                homeView.mapView.addAnnotation(pin)
            }
        } else {
            homeView.mapView.addAnnotation(pin)
        }
    }
    
    //MARK: - 어노테이션 모두 지우기
    func removeAllPin() {
        homeView.mapView.removeAnnotations(homeView.mapView.annotations)
    }
    
    override func bindData() {
        //MARK: - 플로팅 버튼 클릭 시 화면 푸시
        homeView.floatingButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                let studyVC = StudyInputViewController()
                vc.navigationController?.pushViewController(studyVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        //MARK: - GPS 버튼 구현
        homeView.locationButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                guard let loc = vc.locationManager.location?.coordinate else {
                    vc.checkUserDeviceLocationServiceAuthorization()
                    return
                }
                vc.setRegionAndAnnotation(center: loc)
                //MARK: - GPS 버튼 클릭 시 search
                vc.searchMate()
            }
            .disposed(by: disposeBag)
        
        //MARK: - 성별 필터 버튼(Input, Output)
        let input = HomeViewModel.Input(allTap: homeView.allButton.rx.tap, maleTap: homeView.maleButton.rx.tap, femaleTap: homeView.femaleButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        //MARK: - 성별 필터 기능
        output.filterTap
            .withUnretained(self)
            .bind { (vc, tap ) in
                vc.changeFilter(type: tap)
                vc.genderFilter(type: tap)
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - 어노테이션 필터링 기능
    func genderFilter(type: GenderFilterTap) {
        switch type {
        case .all:
            removeAllPin()
            AnnotationList.allList.forEach { addPin(type: $0.type, lat: $0.lat, long: $0.long, gender: $0.gender) }
        case .female:
            removeAllPin()
            AnnotationList.femaleList.forEach { addPin(type: $0.type, lat: $0.lat, long: $0.long, gender: $0.gender) }
        case .male:
            removeAllPin()
            AnnotationList.maleList.forEach { addPin(type: $0.type, lat: $0.lat, long: $0.long, gender: $0.gender) }
        }
    }
    
    //MARK: - 성별 필터 버튼 클릭 시 버튼 색상 변경
    func changeFilter(type: GenderFilterTap) {
        switch type {
        case .all:
            homeView.allButton.backgroundColor = BrandColor.green
            homeView.allButton.configuration?.attributedTitle?.foregroundColor = BlackNWhite.white
            homeView.femaleButton.backgroundColor = BlackNWhite.white
            homeView.femaleButton.configuration?.attributedTitle?.foregroundColor = BlackNWhite.black
            homeView.maleButton.backgroundColor = BlackNWhite.white
            homeView.maleButton.configuration?.attributedTitle?.foregroundColor = BlackNWhite.black
        case .female:
            homeView.allButton.backgroundColor = BlackNWhite.white
            homeView.allButton.configuration?.attributedTitle?.foregroundColor = BlackNWhite.black
            homeView.femaleButton.backgroundColor = BrandColor.green
            homeView.femaleButton.configuration?.attributedTitle?.foregroundColor = BlackNWhite.white
            homeView.maleButton.backgroundColor = BlackNWhite.white
            homeView.maleButton.configuration?.attributedTitle?.foregroundColor = BlackNWhite.black
        case .male:
            homeView.allButton.backgroundColor = BlackNWhite.white
            homeView.allButton.configuration?.attributedTitle?.foregroundColor = BlackNWhite.black
            homeView.femaleButton.backgroundColor = BlackNWhite.white
            homeView.femaleButton.configuration?.attributedTitle?.foregroundColor = BlackNWhite.black
            homeView.maleButton.backgroundColor = BrandColor.green
            homeView.maleButton.configuration?.attributedTitle?.foregroundColor = BlackNWhite.white
        }
    }
    
    //MARK: - 중복 통신 제한 기능
    func limitAPI() {
        limit = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.limit = false
        }
    }
    
    //MARK: - search API 통신
    func searchMate() {
        let searchCo = homeView.mapView.centerCoordinate
        UserDefaultsManager.lat = searchCo.latitude
        UserDefaultsManager.long = searchCo.longitude
        if limit == false {
            APIService.searchAround { [weak self] (value, statusCode, error) in
                guard let statusCode = statusCode else { return }
                guard let status = NetworkError(rawValue: statusCode) else { return }
                switch status {
                case .success:
                    //MARK: - 중복 통신 제한 기능
                    self?.limitAPI()
                    //MARK: - 통신 후 어노테이션 찍어주기
                    AnnotationList.allList.removeAll()
                    self?.removeAllPin()
                    value?.fromQueueDB.forEach { pin in
                        AnnotationList.allList.append(AnnotationList(type: pin.sesac, lat: pin.lat, long: pin.long, gender: pin.gender))
                        self?.addPin(type: pin.sesac, lat: pin.lat, long: pin.long, gender: pin.gender)
                    }
                case .invalidToken: self?.refreshToken()
                default: self?.showToast("잠시 후 다시 시도해주세요.")
                }
            }
        } else { return }
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
                APIService.searchAround { [weak self] (value, status, error) in
                    guard let status = status else { return }
                    guard let networkCode = NetworkError(rawValue: status) else { return }
                    switch networkCode {
                    case .success:
                        //MARK: - 통신 후 어노테이션 찍어주기
                        AnnotationList.allList.removeAll()
                        self?.removeAllPin()
                        value?.fromQueueDB.forEach { pin in
                            AnnotationList.allList.append(AnnotationList(type: pin.sesac, lat: pin.lat, long: pin.long, gender: pin.gender))
                            self?.addPin(type: pin.sesac, lat: pin.lat, long: pin.long, gender: pin.gender)
                        }
                    default: self?.showToast("잠시 후 다시 시도해 주세요.")
                    }
                }
            }
        }
    }
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //MARK: - 사용자가 맵을 움직일 때(이동, 확대, 축소 등) search
        searchMate()
        //지도 인터렉션 금지
        mapView.isUserInteractionEnabled = false
        //0.8초 후 인터렉션 가능
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            mapView.isUserInteractionEnabled = true
        }
    }
    
    //MARK: - 지도의 어노테이션 커스텀
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? AnnotationType else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "\(annotation.identifier)")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "\(annotation.identifier)")
            annotationView?.canShowCallout = false
            annotationView?.contentMode = .scaleAspectFit
        } else {
            annotationView?.annotation = annotation
        }
        
        let sesacImage: UIImage!
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        
        switch annotation.identifier {
        case 0: sesacImage = Icons.sesacFace1
        case 1: sesacImage = Icons.sesacFace2
        case 2: sesacImage = Icons.sesacFace3
        case 3: sesacImage = Icons.sesacFace4
        case 4: sesacImage = Icons.sesacFace5
        default: sesacImage = Icons.sesacFace1
        }
        
        sesacImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView?.image = resizedImage
        
        return annotationView
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
        //MARK: - 위치 거부 할 경우 영등포 캠퍼스로 이동
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
        //MARK: - 위치 권한이 변경될 때 search
        searchMate()
        checkUserDeviceLocationServiceAuthorization()
    }
    
    //MARK: - 위치를 성공적으로 가지고 온 경우 실행
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last?.coordinate else { return }
        //MARK: - CoreLocation 메서드를 통해 위치가 업데이트 될 때 search
        searchMate()
        setRegionAndAnnotation(center: loc)
        locationManager.stopUpdatingLocation()
    }
    
    //MARK: - 위치 가져오지 못한 경우 실행(권한 거부시)
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showRequestLocationServiceAlert()
    }
}
