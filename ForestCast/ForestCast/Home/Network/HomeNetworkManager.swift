//
//  HomeNetworkManager.swift
//  ForestCast
//
//  Created by Marie Harmsen on 03/04/2025.
//
import FirebaseDatabase

protocol HomeNetworkManagerProtocol {
    func fetchCurrentWeatherData(lat: String, long: String, completion: @escaping(CurrentWeatherModel?) -> Void)
    func fetchForecastWeatherData(lat: String, long: String, completion: @escaping(ForecastWeatherModel?) -> Void)
    func fetchAPIWeatherKey(completion: @escaping(String?) -> Void)
}

class HomeNetworkManager: HomeNetworkManagerProtocol {
    
    private let networkLogger = NetworkLogger()
    
    func fetchCurrentWeatherData(lat: String, long: String, completion: @escaping(CurrentWeatherModel?) -> Void) {
        fetchAPIWeatherKey { [weak self] apiKey in
            guard let self = self else { return }
            guard let apiKey = apiKey else {
                networkLogger.logError(error: "Failed to get current API key")
                completion(nil)
                return
            }
            guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric") else {
                completion(nil)
                networkLogger.logError(error: "Malformed current weather URL")
                return
            }
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let data = data {
                    completion(self?.decodeCurrentWeatherData(data))
                } else {
                    self?.networkLogger.logError(error: "Failed to fetch current weather")
                    completion(nil)
                }
            }
            task.resume()
        }
    }
    
    func fetchForecastWeatherData(lat: String, long: String, completion: @escaping(ForecastWeatherModel?) -> Void) {
        fetchAPIWeatherKey { [weak self] apiKey in
            guard let self = self else { return }
            guard let apiKey = apiKey else {
                networkLogger.logError(error: "Failed to get forecast API key")
                completion(nil)
                return
            }
            guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric") else {
                networkLogger.logError(error: "Malformed forecast URL")
                completion(nil)
                return
            }
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let data = data {
                    completion(self?.decodeForecastWeatherData(data))
                } else {
                    self?.networkLogger.logError(error: "Failed to decode forecast weather")
                    completion(nil)
                }
            }
            task.resume()
        }
    }
    
    func fetchAPIWeatherKey(completion: @escaping(String?) -> Void) {
        let reference = Database.database().reference()
        reference.child("APIWeatherKey").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            if let apiKey = snapshot.value as? String {
                completion(apiKey)
            } else {
                self?.networkLogger.logError(error: "Failed to fetch API key")
                completion(nil)
            }
        }) { [weak self] error in
            self?.networkLogger.logError(error: "Failed to fetch API key \(error)")
            completion(nil)
        }
    }
    
    private func decodeCurrentWeatherData(_ data: Data) -> CurrentWeatherModel? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let decodeData = try decoder.decode(CurrentWeatherData.self, from: data)
            
            let temperatureMin = decodeData.main.tempMin
            let temperatureMax = decodeData.main.tempMax
            let temperature = decodeData.main.temp
            guard let weatherTypeString = decodeData.weather.first?.main.lowercased(),
                  let weatherType = WeatherType(rawValue: weatherTypeString) else {
                networkLogger.logError(error: "Failed to convert weather type")
                return nil
            }
            return CurrentWeatherModel(temperature: temperature, temperatureMin: temperatureMin,
                                       temperatureMax: temperatureMax, weatherType: weatherType)
        } catch {
            networkLogger.logError(error: "Failed to decode current weather")
            return nil
        }
    }
    
    private func decodeForecastWeatherData(_ data: Data) -> ForecastWeatherModel? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let decodeData = try decoder.decode(ForecastWeatherData.self, from: data)
            
            var allForecastDays = [ForecastDays]()
            let _ = decodeData.list.prefix(5).map { forecast in
                let temp = forecast.main.temp
                guard let weatherTypeString = forecast.weather.first?.main.lowercased(),
                      let weatherType = WeatherType(rawValue: weatherTypeString) else {
                    networkLogger.logError(error: "Failed to decode weather type")
                    return
                }
                let days = ForecastDays(dayOfWeek: "Monday", temp: temp, weatherType: weatherType)
                allForecastDays.append(days)
            }
            
            return ForecastWeatherModel(forecastDays: allForecastDays)
        } catch {
            networkLogger.logError(error: "Failed to decode forecast weather")
            return nil
        }
    }
}
