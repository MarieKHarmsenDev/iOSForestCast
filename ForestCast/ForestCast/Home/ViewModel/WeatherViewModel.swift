//
//  WeatherViewModel.swift
//  ForestCast
//
//  Created by Marie Harmsen on 04/04/2025.
//
import SwiftUI
import CoreLocation

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

class WeatherViewModel: NSObject, ObservableObject {
    
    var cities = [String]()
    
    var apiKey: String?
    var location: Location?
    var network: WeatherNetworkManagerProtocol?
    var networkLogger = NetworkLogger()
    var currentWeather: CurrentWeatherModel?
    var forecastWeather: ForecastWeatherModel?
    @Published var shouldShowError = false
    @Published var isLoading = true
    @Published var containsFavourite: Bool = false
    private var favourites = FavouritesManager()
    
    init(apiKey: String, location: Location, network: WeatherNetworkManagerProtocol) {
        super.init()
        self.apiKey = apiKey
        self.location = location
        self.network = network
        fetchData()
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        guard let location = location,
            let apiKey = apiKey else {
            return
        }
        let lat = String(describing: location.latitude)
        let long = String(describing: location.longitude)
        
        group.enter()
        network?.fetchCurrentWeatherData(apiKey: apiKey,
                                        lat: lat,
                                        long: long) { [weak self] result in
            switch result {
            case .success(let weather):
                self?.currentWeather = weather
                group.leave()
            case .failure(let error):
                self?.networkLogger.logError("Failed to fetch current weather \(error)")
                DispatchQueue.main.async {
                    self?.shouldShowError = true
                }
            }
        }
        
        group.enter()
        network?.fetchForecastWeatherData(apiKey: apiKey,
                                         lat: lat,
                                         long: long) { [weak self] result in
            switch result {
            case .success(let forecast):
                self?.forecastWeather = forecast
                group.leave()
            case .failure(let error):
                self?.networkLogger.logError("Failed to fetch forecast weather \(error)")
                DispatchQueue.main.async {
                    self?.shouldShowError = true
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.isLoading = false
            self?.updateIcon()
        }
        
    }
    
    var backgroundColor: Color {
        switch currentWeather?.weatherType {
        case .clear:
            return Color.sunny
        case .clouds:
            return Color.cloudy
        case .rain:
            return Color.rainy
        case .none:
            return Color.black
        }
    }
    
    var descriptionLocalized: String {
        switch currentWeather?.weatherType {
        case .clear:
            return "weatherScreen.sunny".localized
        case .clouds:
            return "weatherScreen.cloudy".localized
        case .rain:
            return "weatherScreen.rainy".localized
        case .none:
            return ""
        }
    }
    
    func updateFavourites() {
        guard let currentWeather = currentWeather, let location = location else {
            return
        }
        let favourite = FavouritesWeatherModel(id: currentWeather.id,
                                               name: currentWeather.name,
                                               location: location)
        if favourites.contains(favourite) {
            favourites.remove(favourite)
        } else {
            favourites.add(favourite)
        }
        updateIcon()
    }
    
    func updateIcon() {
        guard let currentWeather = currentWeather, let location = location else {
            return
        }
        let favourite = FavouritesWeatherModel(id: currentWeather.id,
                                               name: currentWeather.name,
                                               location: location)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.containsFavourite = self.favourites.contains(favourite)
        }
    }
}
