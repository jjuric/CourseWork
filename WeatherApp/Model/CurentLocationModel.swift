//
//  Location.swift
//  WeatherApp
//
//  Created by Jakov Juric on 09/01/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import Foundation
import CoreLocation

class CurrentLocationModel: NSObject {
    let locationManager = CLLocationManager()
    var onGotLocation: ((CLLocationCoordinate2D)->Void)?
    
    override init() {
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension CurrentLocationModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.startMonitoringSignificantLocationChanges()
        case .authorizedAlways:
            locationManager.startMonitoringSignificantLocationChanges()
        default:
            print("Problem with didChangeAuthorization")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            onGotLocation?(currentLocation.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager didFailWithError: \(error)")
    }
}
