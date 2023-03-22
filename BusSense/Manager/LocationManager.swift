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
    @Published var locationPermission: CLAuthorizationStatus?
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
        
        self.locationPermission = status
        
        switch status {
            case .notDetermined:
                print("DEBUG: location permission not determined")
            case .restricted:
                print("DEBUG: location permission restricted")
            case .denied:
                print("DEBUG: location permission denied")
            case .authorizedAlways:
                print("Debug: location permission auth always")
            case .authorizedWhenInUse:
                print("DEBUG: location permission auth when in use")
                
            @unknown default:
                break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }
}
