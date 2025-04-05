//
//  ForecastWeatherData.swift
//  ForestCast
//
//  Created by Marie Harmsen on 04/04/2025.
//
import Foundation

struct ForecastWeatherData: Codable {
    let list: [WeatherItem]
}

struct WeatherItem: Codable {
    let main: Main
    let weather: [Weather]
    let dtTxt: String
    let dt: TimeInterval
}
