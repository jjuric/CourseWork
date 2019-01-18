//
//  WeatherForecast.swift
//  WeatherApp
//
//  Created by Jakov Juric on 07/01/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    var list: [List]
    var city: City
}
struct City: Decodable {
    var name: String
    var coord: Coordinates
    var country: String
}
struct Coordinates: Decodable {
    var lat: Double
    var lon: Double
}
struct List: Decodable {
    var dt: Int
    var main: Main
    var weather: [Weather]
    var dt_txt: String
    
    var dt_hours: String {
        let dateHours = dt_txt.components(separatedBy: " ")
        let hourMinSec = dateHours[1].components(separatedBy: ":")
        return "\(hourMinSec[0])h"
    }
}
struct Main: Decodable {
    var temp: Double
    var temp_min: Double
    var temp_max: Double
}
struct Weather: Decodable {
    var main: String
    var description: String
    var icon: String
    
    var imageData: Data? {
        if let url = URL(string: "https://openweathermap.org/img/w/\(icon).png") {
            if let data = try? Data(contentsOf: url) {
                return data
            }
        }
        return nil
    }
}
