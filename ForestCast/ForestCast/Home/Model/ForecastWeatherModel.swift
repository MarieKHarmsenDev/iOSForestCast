//
//  ForecastWeatherModel.swift
//  ForestCast
//
//  Created by Marie Harmsen on 04/04/2025.
//
import Foundation

struct ForecastDays {
    let dayOfWeek: String
    let temp: Double
    let weatherType: WeatherType
    
    var temperatureString: String {
        return String(format: "%.f", temp)
    }
}

struct ForecastWeatherModel {
    let forecastDays: [ForecastDays]
}
