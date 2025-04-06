//
//  ForecastWeatherModel.swift
//  ForestCast
//
//  Created by Marie Harmsen on 04/04/2025.
//
import Foundation

struct ForecastDays: Equatable, Identifiable {
    let id = UUID()

    let date: String
    let dateInterval: TimeInterval
    let temprature: Double
    let weatherType: WeatherType
    
    var temperatureString: String {
        return String(format: "%.f", temprature)
    }
    
    var dayOfWeek: String {
        return date.dayOfWeek
    }
}

struct ForecastWeatherModel: Equatable {
    let forecastDays: [ForecastDays]
}
