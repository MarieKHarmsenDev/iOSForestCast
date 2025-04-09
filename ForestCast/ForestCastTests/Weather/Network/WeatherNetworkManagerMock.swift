//
//  WeatherNetworkManagerMock.swift
//  ForestCast
//
//  Created by Marie Harmsen on 06/04/2025.
//
@testable import ForestCast

class WeatherNetworkManagerMock: WeatherNetworkManagerProtocol {
    
    private var weatherType: WeatherType
    private var responseType: ResponseType
    private var isNewFavourite: Bool = false
    
    init(weatherType: WeatherType, responseType: ResponseType, isNewFavourite: Bool = false) {
        self.weatherType = weatherType
        self.responseType = responseType
        self.isNewFavourite = isNewFavourite
    }
    
    func fetchCurrentWeatherData(lat: String, long: String, completion: @escaping (Result<ForestCast.CurrentWeatherModel?, ForestCast.NetworkError>) -> Void) {
        switch responseType {
        case .success:
            if isNewFavourite {
                return completion(.success(CurrentWeatherModel(temperature: 50, temperatureMin: 100, temperatureMax: 20, weatherType: weatherType, name: "Tokyo", id: 3)))
            } else {
                return completion(.success(CurrentWeatherModel(temperature: 11.1, temperatureMin: 12.1, temperatureMax: 11.5, weatherType: weatherType, name: "Johannesburg", id: 1)))

            }
        case .failure:
            return completion(.failure(NetworkError.connectionError))
        }
    }
    
    func fetchForecastWeatherData(lat: String, long: String, completion: @escaping (Result<ForestCast.ForecastWeatherModel?, ForestCast.NetworkError>) -> Void) {
        switch responseType {
        case .success:
            let forecastDays = ForecastDays(date: "2025-04-04 18:00:00", dateInterval: 111111, temprature: 11.1, weatherType: weatherType)
            return completion(.success(ForecastWeatherModel(forecastDays: [forecastDays])))
        case .failure:
            return completion(.failure(NetworkError.connectionError))
        }
    }
}
