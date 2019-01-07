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

class Networking {
    var apiUrl: String
    var currentWeather: Weather!
    
    init(api: String) {
        self.apiUrl = api
    }
    
    func fetchJSON() {
        Alamofire.request(apiUrl).responseJSON { response in
            if let json = response.data {
                let decoder = JSONDecoder()
                
                if let weather = try? decoder.decode(Weather.self, from: json) {
                    self.currentWeather = weather
                    print(weather.name)
                }
            }
        }
    }
}
