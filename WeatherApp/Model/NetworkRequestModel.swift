//
//  Location.swift
//  WeatherApp
//
//  Created by Jakov Juric on 06/01/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

class NetworkRequestModel {
    private var apiKey = "f7a0220a4efbafcd96e787fe94aa761c"
    private var apiUrl = ""
    
    func getWeatherData(coordinates: CLLocationCoordinate2D, success: @escaping (_ weatherData: WeatherDataCurrent) -> Void ) {
        apiUrl = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&APPID=\(apiKey)"
        Alamofire.request(apiUrl).responseJSON { response in
            if let json = response.data {
                let decoder = JSONDecoder()
                
                if let weather = try? decoder.decode(WeatherDataCurrent.self, from: json) {
                    success(weather)
                }
            }
        }
    }
    
    func getWeatherForecast(coordinates: CLLocationCoordinate2D, success: @escaping (_ WeatherData: WeatherData) -> Void) {
        apiUrl = "https://api.openweathermap.org/data/2.5/forecast?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&APPID=\(apiKey)"
        Alamofire.request(apiUrl).responseJSON { response in
            if let json = response.data {
                let decoder = JSONDecoder()
                
                if let weather = try? decoder.decode(WeatherData.self, from: json) {
                    success(weather)
                }
            }
        }
    }
}
