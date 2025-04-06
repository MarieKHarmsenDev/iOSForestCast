//
//  CurrentWeatherModel.swift
//  ForestCast
//
//  Created by Marie Harmsen on 03/04/2025.
//

enum WeatherType: String {
    case clear
    case rainy
    case clouds
}

struct CurrentWeatherModel: Equatable {
    let temperature: Double
    let temperatureMin: Double
    let temperatureMax: Double
    let weatherType: WeatherType
    
    var temperatureString: String {
        return String(format: "%.f", temperature) + "°"
    }
    
    var temperatureMinString: String {
        return String(format: "%.f", temperatureMin) + "°"
    }
    
    var temperatureMaxString: String {
        return String(format: "%.f", temperatureMax) + "°"
    }
}
