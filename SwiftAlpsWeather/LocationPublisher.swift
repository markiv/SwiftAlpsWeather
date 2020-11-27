//
//  LocationPublisher.swift
//  SwiftAlpsWeather
//
//  Created by Vikram Kriplaney on 27.11.20.
//

import CoreLocation

class LocationModel: NSObject, ObservableObject {
    @Published var location: CLLocation?
    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
    }
}

extension LocationModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            manager.desiredAccuracy = 100
            manager.startUpdatingLocation()
        default: break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
}
