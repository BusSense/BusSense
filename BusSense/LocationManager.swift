//
//  LocationManager.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 2/20/23.
//
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    static let shared = LocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .notDetermined:
                print("DEBUG: not determined")
            case .restricted:
                print("DEBUG: restricted")
            case .denied:
                print("DEBUG: denied")
            case .authorizedAlways:
                print("Debug: auth always")
            case .authorizedWhenInUse:
                print("DEBUG: auth when in use")
                
            @unknown default:
                break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }
}
