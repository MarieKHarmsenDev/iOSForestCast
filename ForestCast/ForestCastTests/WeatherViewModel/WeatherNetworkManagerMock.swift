//
//  WeatherNetworkManagerMock.swift
//  ForestCast
//
//  Created by Marie Harmsen on 06/04/2025.
//
@testable import ForestCast

class WeatherNetworkManagerMock: WeatherNetworkManagerProtocol {
    
    private var weatherType: WeatherType
    
    init(weatherType: WeatherType) {
        self.weatherType = weatherType
    }
    
    func fetchCurrentWeatherData(completion: @escaping (Result<CurrentWeatherModel?, NetworkError>) -> Void) {
        return completion(.success(CurrentWeatherModel(temperature: 11.1, temperatureMin: 11.2, temperatureMax: 11.5, weatherType: weatherType, name: "Johannesburg", id: 123)))
    }
    
    func fetchForecastWeatherData(completion: @escaping (Result<ForecastWeatherModel?, NetworkError>) -> Void) {
            let forecastDays = ForecastDays(date: "2025-04-04 18:00:00", dateInterval: 111111, temprature: 11.1, weatherType: weatherType)
            return completion(.success(ForecastWeatherModel(forecastDays: [forecastDays])))
    }
}
