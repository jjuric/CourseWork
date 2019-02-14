//
//  WeatherDataCurrent.swift
//  WeatherApp
//
//  Created by Jakov Juric on 09/01/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import Foundation

struct WeatherDataCurrent: Decodable {
    var coord: Coordinates
    var weather: [Weather]
    var main: Main
    var name: String
}
