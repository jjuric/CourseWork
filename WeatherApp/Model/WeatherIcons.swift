//
//  WeatherIcons.swift
//  WeatherApp
//
//  Created by Jakov Juric on 13/02/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import Foundation

enum WeatherIcons: String {
    case clearSky = "sunny"
    case clouds = "cloudy"
    case rain = "drizzle"
    case thunder = "storm"
    case snow = "snow"
    case mist = "fog"
    
    var background: String {
        switch self {
        case .clearSky:
            return "bgclear"
        case .clouds:
            return "bgcloudy"
        case .rain:
            return "bgdrizzle"
        case .thunder:
            return "bgthunder"
        case .snow:
            return "bgsnow"
        case .mist:
            return "bgfog"
        }
    }
    
    init(_ icon: String) {
        switch icon {
        case "01d", "01n":
            self = .clearSky
        case "02d", "02n", "03d", "03n", "04d", "04n":
            self = .clouds
        case "09n", "09d", "10d", "10n":
            self = .rain
        case "11d", "11n":
            self = .thunder
        case "13d", "13n":
            self = .snow
        default:
            self = .mist
        }
    }
}
