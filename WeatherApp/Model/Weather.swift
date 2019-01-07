//
//  Weather.swift
//  WeatherApp
//
//  Created by Jakov Juric on 06/01/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import Foundation

struct Weather: Codable {
    var coord: Coordinate
    var weather: [WeatherInfo]
    var name: String
}

struct Coordinate: Codable {
    var lon: Double
    var lat: Double
}
struct WeatherInfo: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}
