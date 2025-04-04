//
//  HomeNetworkManager.swift
//  ForestCast
//
//  Created by Marie Harmsen on 03/04/2025.
//
import FirebaseDatabase

protocol HomeNetworkManagerProtocol {
    func fetchWeatherData(lat: String, long: String)
    func fetchAPIWeatherKey(completion: @escaping(String?) -> Void)
    func fetchCurrentWeatherData(url: URL)
}

class HomeNetworkManager {
    private var currentWeather: CurrentWeatherModel?
    
    func fetchWeatherData(lat: String, long: String) {
        fetchAPIWeatherKey { [weak self] apiKey in
            guard let self = self else { return }
            guard let apiKey = apiKey else {
                print("error")
                return
            }
            
            guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)") else {
                print("error 111")
                return
            }
            self.fetchCurrentWeatherData(url: url)
        }
    }
    
    private func fetchAPIWeatherKey(completion: @escaping(String?) -> Void) {
        let reference = Database.database().reference()
        reference.child("APIWeatherKey").observeSingleEvent(of: .value, with: { snapshot in
            if let apiKey = snapshot.value as? String {
                completion(apiKey)
            } else {
                completion(nil)
            }
        }) { error in
            completion(nil)
        }
    }
    
    private func fetchCurrentWeatherData(url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data {
                self?.decodeData(data)
            } else {
                print("error 1")
            }
        }
        task.resume()
    }
    
    private func decodeData(_ data: Data) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }
            let decodeData = try decoder.decode(CurrentWeatherData.self, from: data)
            
            let tempMin = decodeData.main.tempMin
            let tempMax = decodeData.main.tempMax
            let temp = decodeData.main.temp
            guard let weatherTypeString = decodeData.weather.first?.main.lowercased(),
                  let weatherType = WeatherType(rawValue: weatherTypeString) else {
                print("error 3")
                return
            }
            currentWeather = CurrentWeatherModel(temp: temp, tempMin: tempMin, tempMax: tempMax, weatherType: weatherType)
        } catch {
            print("error")
        }
    }
}
