//
//  FavoriteCities.swift
//  WeatherApp
//
//  Created by Jakov Juric on 07/02/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import Foundation

class FavoriteCity: Codable {
    var name: String
    var coordinate: Coordinates
    
    init(name: String, coordinate: Coordinates) {
        self.name = name
        self.coordinate = coordinate
    }
}
