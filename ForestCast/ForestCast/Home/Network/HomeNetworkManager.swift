//
//  HomeNetworkManager.swift
//  ForestCast
//
//  Created by Marie Harmsen on 03/04/2025.
//
import FirebaseDatabase

enum NetworkError: Error {
    case apiKey
    case malformedURL
    case decodeDataProblem
    case noData
}

protocol HomeNetworkManagerProtocol {
    func fetchCurrentWeatherData(lat: String, long: String, completion: @escaping(Result<CurrentWeatherModel?, NetworkError>) -> Void)
    func fetchForecastWeatherData(lat: String, long: String, completion: @escaping(Result<ForecastWeatherModel?, NetworkError>) -> Void)
    func fetchAPIWeatherKey(completion: @escaping(String?) -> Void)
}

class HomeNetworkManager: HomeNetworkManagerProtocol {
    
    private let networkLogger = NetworkLogger()
    
    func fetchCurrentWeatherData(lat: String, long: String, completion: @escaping(Result<CurrentWeatherModel?, NetworkError>) -> Void) {
        fetchAPIWeatherKey { [weak self] apiKey in
            guard let self = self else { return }
            if let apiKey = apiKey {
                guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric") else {
                    completion(.failure(.malformedURL))
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    if let data = data {
                        completion(.success(self?.decodeCurrentWeatherData(data)))
                    } else {
                        self?.networkLogger.logError(error: "Failed to fetch current weather")
                        completion(.failure(.noData))
                    }
                }
                task.resume()
            } else {
                completion(.failure(.noData))
            }
        }
    }
    
    func fetchForecastWeatherData(lat: String, long: String, completion: @escaping(Result<ForecastWeatherModel?, NetworkError>) -> Void) {
        fetchAPIWeatherKey { [weak self] apiKey in
            guard let self = self else { return }
            if let apiKey = apiKey {
                guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric") else {
                    networkLogger.logError(error: "Malformed forecast URL")
                    completion(.failure(.malformedURL))
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    if let data = data {
                        completion(.success(self?.decodeForecastWeatherData(data)))
                    } else {
                        self?.networkLogger.logError(error: "Failed to decode forecast weather")
                        completion(.failure(.decodeDataProblem))
                    }
                }
                task.resume()
            } else {
                completion(.failure(.noData))
            }
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
        })
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
            for forecast in decodeData.list {
                let date = forecast.dtTxt
                let dateInterval = forecast.dt
                let temprature = forecast.main.temp
                guard let weatherTypeString = forecast.weather.first?.main.lowercased(),
                      let weatherType = WeatherType(rawValue: weatherTypeString) else {
                    networkLogger.logError(error: "Failed to decode weather type")
                    return nil
                }
                let days = ForecastDays(date: date, dateInterval: dateInterval, temprature: temprature, weatherType: weatherType)
                allForecastDays.append(days)
            }
            let currentHour = Calendar.current.component(.hour, from: Date())
            
            return ForecastWeatherModel(forecastDays: getFilteredForecastDaysBasedOnClosestTime(allForecastDays: allForecastDays, closestHour: currentHour))
        } catch {
            networkLogger.logError(error: "Failed to decode forecast weather")
            return nil
        }
    }
    
    private func getFilteredForecastDaysBasedOnClosestTime(allForecastDays: [ForecastDays], closestHour: Int) -> [ForecastDays] {
        var forecastResults = [ForecastDays]()
        let groupedByDay = Dictionary(grouping: allForecastDays) { entry in
            return String(entry.date.day)
        }
        
        let sortedgroups = groupedByDay.keys.sorted()
        
        for (_, date) in sortedgroups.enumerated() {
            guard let entries = groupedByDay[date] else { continue }
            let closest = entries.min(by: { a,b in
                let aHour = Calendar.current.component(.hour, from: Date(timeIntervalSince1970: a.dateInterval))
                let bHour = Calendar.current.component(.hour, from: Date(timeIntervalSince1970: b.dateInterval))
                return abs(aHour-closestHour) < abs(bHour-closestHour)
            })
            
            if let closest = closest {
                forecastResults.append(closest)
            }
        }
        return forecastResults
    }
}
