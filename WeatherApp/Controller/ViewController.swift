//
//  ViewController.swift
//  WeatherApp
//
//  Created by Jakov Juric on 06/01/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

var API_URL =  ""

class ViewController: UIViewController {
    
    @IBOutlet weak var forecastTableView: UITableView!
    let locationManager = CLLocationManager()
    let location = CurrentLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
//        checkLocationServices()
        location.checkLocationServices()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Test"
        cell.detailTextLabel?.text = "Subtest"
        return cell
    }
    
}

//extension ViewController: CLLocationManagerDelegate {
//    func checkLocationServices() {
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            checkLocationAuthorization()
//        } else {
//            print("Location services disabled")
//        }
//    }
//
//    func checkLocationAuthorization() {
//        switch CLLocationManager.authorizationStatus() {
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        case .authorizedWhenInUse:
//            locationManager.requestLocation()
//        default:
//            print("Error in authorization status")
//            break
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        API_URL = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&APPID=f7a0220a4efbafcd96e787fe94aa761c"
//        Networking(api: API_URL).fetchJSON()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        checkLocationAuthorization()
//    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("LocationManager didFailWithError: \(error)")
//    }
//}
