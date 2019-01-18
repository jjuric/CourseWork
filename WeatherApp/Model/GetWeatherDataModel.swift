//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Jakov Juric on 09/01/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import Foundation
import CoreLocation

class GetWeatherDataModel {
    var request = NetworkRequestModel()
    var fiveDayForecast: [List] = []
    var onGotData: ((WeatherDataCurrent)->Void)?
    var onGotForecast: (()->Void)?

    func getForecast(coordinate: CLLocationCoordinate2D) {
        request.getWeatherForecast(coordinates: coordinate) { [weak self] data in
            let firstFive = Array(data.list.prefix(5))
            self?.fiveDayForecast = firstFive
            self?.onGotForecast?()
        }
    }
    func getWeather(coordinates: CLLocationCoordinate2D) {
        request.getWeatherData(coordinates: coordinates) { [weak self] data in
            self?.onGotData?(data)
        }
    }
}
