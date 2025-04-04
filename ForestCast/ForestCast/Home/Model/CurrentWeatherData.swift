//
//  CurrentWeatherData.swift
//  ForestCast
//
//  Created by Marie Harmsen on 03/04/2025.
//

struct CurrentWeatherData: Codable {
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
}

struct Weather: Codable {
    let main: String
}
