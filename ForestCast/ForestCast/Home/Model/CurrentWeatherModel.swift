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

struct CurrentWeatherModel {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    let weatherType: WeatherType
    
    var tempString: String {
        return String(format: "%.f", temp)
    }
    
    var tempMinString: String {
        return String(format: "%.f", tempMin)
    }
    
    var tempMaxString: String {
        return String(format: "%.f", tempMax)
    }
}
