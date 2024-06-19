//
//  ViewController2.swift
//  MyProject
//
//  Created by 김마리아 on 6/17/24.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class ViewController2: UIViewController, CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate {

    var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    let placesClient = GMSPlacesClient.shared()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 위치 관리자 설정
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // 지도 초기 설정 - 한성대학교 위치
        let camera = GMSCameraPosition.camera(withLatitude: 37.5827, longitude: 127.0109, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.isMyLocationEnabled = true
        self.view.addSubview(mapView)
        
        // 한성대학교 마커 추가
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 37.5827, longitude: 127.0109)
        marker.title = "Hansung University"
        marker.snippet = "Seoul, South Korea"
        marker.map = mapView
        
        // 검색 버튼 추가
        let searchButton = UIButton(type: .system)
        searchButton.setTitle("Search", for: .normal)
        searchButton.addTarget(self, action: #selector(presentAutocomplete), for: .touchUpInside)
        searchButton.frame = CGRect(x: 20, y: 40, width: 100, height: 40)
        self.view.addSubview(searchButton)
    }
    
    @objc func presentAutocomplete() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }

    // GMSAutocompleteViewControllerDelegate 메서드
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        
        // placeID가 nil이 아닌 경우에만 장소 정보를 가져옴
        guard let placeID = place.placeID else {
            print("Error: placeID is nil")
            return
        }

        placesClient.lookUpPlaceID(placeID) { (place, error) in
            guard error == nil, let place = place else {
                print("An error occurred: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // 장소의 위치로 카메라 이동 및 마커 추가
            self.updateMapLocation(to: place.coordinate, withTitle: place.name)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        dismiss(animated: true, completion: nil)
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // 지도 위치 업데이트 함수
    private func updateMapLocation(to coordinate: CLLocationCoordinate2D, withTitle title: String?) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15.0)
        mapView.animate(to: camera)
        
        let marker = GMSMarker()
        marker.position = coordinate
        marker.title = title
        marker.map = mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied or restricted.")
        default:
            break
        }
    }
    
    // 현재 위치 업데이트
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // 현재 위치로 카메라 이동 및 확대/축소 설정
        updateMapLocation(to: location.coordinate, withTitle: "You are here")
    }

    // 위치 업데이트 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
