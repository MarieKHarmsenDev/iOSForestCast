//
//  CurrentWeatherModel.swift
//  ForestCast
//
//  Created by Marie Harmsen on 03/04/2025.
//

enum WeatherType: String {
    case sunny
    case rainy
    case clouds
}

struct CurrentWeatherModel {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    let weatherType: WeatherType
}
