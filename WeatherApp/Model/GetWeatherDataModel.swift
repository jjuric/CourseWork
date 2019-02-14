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
    var onGotError: ((String)->Void)?

    func getWeather(coordinates: CLLocationCoordinate2D) {
        request.getWeatherData(coordinates: coordinates) { [weak self] response in
            switch response {
            case .Success(let .Current(data)):
                self?.onGotData?(data)
            case .Error(let error):
                self?.onGotError?(error)
            case .Success( .Forecast(_)):
                return
            }
        }
    }
    func getForecast(coordinates: CLLocationCoordinate2D) {
        request.getForecastData(coordinates: coordinates) { [weak self] response in
            switch response {
            case .Success(let .Forecast(data)):
                let firstFive = Array(data.list.prefix(5))
                self?.fiveDayForecast = firstFive
                self?.onGotForecast?()
            case .Error(let error):
                self?.onGotError?(error)
            case .Success( .Current(_)):
                return
            }
        }
    }
    
}
