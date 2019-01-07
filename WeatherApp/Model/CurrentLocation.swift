//
//  CurrentLocation.swift
//  WeatherApp
//
//  Created by Jakov Juric on 07/01/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import Foundation
import CoreLocation

class CurrentLocation: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            checkLocationAuthorization()
        } else {
            print("Location services disabled")
        }
    }
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            print("Error in authorization status")
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        API_URL = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&APPID=f7a0220a4efbafcd96e787fe94aa761c"
        Networking(api: API_URL).fetchJSON()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager didFailWithError: \(error)")
    }
}
