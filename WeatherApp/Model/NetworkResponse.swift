//
//  File.swift
//  WeatherApp
//
//  Created by Jakov Juric on 18/01/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import Foundation
enum ForecastOrCurrent {
    case Forecast(WeatherData)
    case Current(WeatherDataCurrent)
}
enum NetworkResponse {
    case Success(response: ForecastOrCurrent)
    case Error(error: String)
}


