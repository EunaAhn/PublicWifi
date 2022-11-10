//
//  ViewController.swift
//  WifiFinder
//
//  Created by Euna Ahn on 2022/08/16.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapKitView: MKMapView!
    
    let sesacCoordinate = CLLocationCoordinate2D(latitude: 37.51818789942772, longitude: 126.88541765534976) //영등포
    
    let locationManager = CLLocationManager() //위치를 조종하게(?) 도와주는 로케이션 매니저를 하나 고용합시다.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.requestWhenInUseAuthorization() //권한요청도 알아서 척척!
        
        //mapKitView.setRegion(MKCoordinateRegion(center: sesacCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
        
        guard let currentLocation = locationManager.location else {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        mapKitView.delegate = self
        locationManager.delegate = self
        
        mapKitView.showsUserLocation = true
        mapKitView.setUserTrackingMode(.follow, animated: true)
        
        
    }
    
    private func addCustomPin() {
        let pin = MKPointAnnotation()
        //포인트 어노테이션은 뭔가요?
        pin.coordinate = sesacCoordinate
        pin.title = "영등포 건물"
        pin.subtitle = "전체 3층짜리 건물"
        mapKitView.addAnnotation(pin)
        
    }
    
    
    func setWifiSelected(name: String, address: String, latitude: Double, longitude: Double) {
        let tmpAddress = name
        let tmpName = address
        let tmpLatitude = latitude
        let tmpLongitude = longitude
        
        print("**\(tmpName) : \(tmpAddress) -> (\(tmpLatitude), \(tmpLongitude))")
        
        let wifiSelectedCoordinate = CLLocationCoordinate2D(latitude: tmpLatitude, longitude: tmpLongitude)
        mapKitView.setRegion(MKCoordinateRegion(center: wifiSelectedCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = wifiSelectedCoordinate
        pin.title = tmpName
        pin.subtitle = tmpAddress
        mapKitView.addAnnotation(pin)
        
    
    }
    
    //권한 설정을 위한 코드들
    func checkCurrentLocationAuthorization(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .restricted:
            print("restricted")
            goSetting()
        case .denied:
            print("denided")
            goSetting()
        case .authorizedAlways:
            print("always")
        case .authorizedWhenInUse:
            print("wheninuse")
            locationManager.startUpdatingLocation()
        @unknown default:
            print("unknown")
        }
        if #available(iOS 14.0, *) {
            let accuracyState = locationManager.accuracyAuthorization
            switch accuracyState {
            case .fullAccuracy:
                print("full")
            case .reducedAccuracy:
                print("reduced")
            @unknown default:
                print("Unknown")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchWifi" {
            let vc = segue.destination as! SearchViewController
            vc.delegate = self
        }
    }
    
    @IBAction func actionSearchWifi(_ sender: Any) {
        performSegue(withIdentifier: "searchWifi", sender: sender)
    }
    
    @IBAction func actionGoHome(_ sender: Any) {
        guard let currentLocation = locationManager.location else {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        mapKitView.delegate = self
        locationManager.delegate = self
        
        mapKitView.showsUserLocation = true
        mapKitView.setUserTrackingMode(.follow, animated: true)
        
        
        //let MycurrentLocation = CLLocationCoordinate2D(latitude: 37.51818789942772, longitude: 126.88541765534976) //영등포
        
        //mapKitView.setRegion(MKCoordinateRegion(center: MycurrentLocation, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
        
        //addCustomPin()
    }
    
    func goSetting() {
        
        let alert = UIAlertController(title: "위치권한 요청", message: "러닝 거리 기록을 위해 항상 위치 권한이 필요합니다.", preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "설정", style: .default) { action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            // 열 수 있는 url 이라면, 이동
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { UIAlertAction in
            
        }
        
        alert.addAction(settingAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //재사용 할 수 있는 어노테이션 만들기! 마치 테이블뷰의 재사용 Cell을 넣어주는 것과 같아요!
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            // 유저 위치를 나타낼때는 기본 파란 그 점 아시죠? 그거 쓰고싶으니까~ 요렇게 해주시고 만약에 쓰고싶은 어노테이션이 있다면 그녀석을 리턴해 주시면 되긋죠? 하하!
            return nil
        }
        //우리가 만들고 싶은 커스텀 어노테이션을 만들어 줍시다. 그냥 뿅 생길 수 없겠죠? 보여주고 싶은 모양을 뷰로 짜준다고 생각하시면 됩니다.
        //즉시 인스턴스로 만들어 줘 보겠습니다요. 어떻게 생겼을지는 아직 안정했지만 일단 커스텀이라는 식별자?를 가진 뷰로 만들어 줬습니다.
        //마커 어노테이션뷰 라는 어노테이션뷰를 상속받는 뷰가 따로있습니다. 풍선모양이라고 하는데 한번 만들어 보시는것도 좋겠네요! 테두리가 있고 안에 내용물을 바꾸는 식으로 설정이 되는듯 해요.
        var annotationView = self.mapKitView.dequeueReusableAnnotationView(withIdentifier: "Custom")
        
        if annotationView == nil {
            //없으면 하나 만들어 주시고
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Custom")
            annotationView?.canShowCallout = true
            
            
            //callOutView를 통해서 추가적인 액션을 더해줄수도 있겠죠! 와 무지 간편합니다!
            let miniButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            miniButton.setImage(UIImage(systemName: "person"), for: .normal)
            miniButton.tintColor = .blue
            annotationView?.rightCalloutAccessoryView = miniButton
            
        } else {
            //있으면 등록된 걸 쓰시면 됩니다.
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "Circle")
        
        //상황에 따라 다른 annotationView를 리턴하게 하면 여러가지 모양을 쓸 수도 있겠죠?
        
        return annotationView
    }
    
    func checkUserLocationServicesAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authorizationStatus: authorizationStatus)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserLocationServicesAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
        checkUserLocationServicesAuthorization()
    }

}

