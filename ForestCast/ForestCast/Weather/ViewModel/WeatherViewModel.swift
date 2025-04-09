//
//  WeatherViewModel.swift
//  ForestCast
//
//  Created by Marie Harmsen on 04/04/2025.
//
import SwiftUI
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject {
    private var location: Location?
    private var networkLogger = NetworkLogger()

    var shouldShowFavourites: Bool = false
    var network: WeatherNetworkManagerProtocol?
    
    var favourites: FavouritesManagerProtocol?

    var currentWeather: CurrentWeatherModel?
    var forecastWeather: ForecastWeatherModel?

    @Published var shouldShowError = false
    @Published var isLoading = true
    @Published var containsFavourite: Bool = false
    
    init(location: Location? = Location(latitude: LocationValuesManager.shared.latitude, longitude: LocationValuesManager.shared.longitude),
         shouldShowFavourites: Bool = true,
         network: WeatherNetworkManagerProtocol,
         favourites: FavouritesManagerProtocol? = nil) {
        super.init()
        self.location = location
        self.network = network
        self.shouldShowFavourites = shouldShowFavourites
        if let favourites = favourites {
            self.favourites = favourites
        }
    }
    
    func fetchData() {
        let group = DispatchGroup()
        guard let location = location else {
            return
        }
        let lat = String(describing: location.latitude)
        let long = String(describing: location.longitude)
        
        group.enter()
        network?.fetchCurrentWeatherData(lat: lat,
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
        network?.fetchForecastWeatherData(lat: lat,
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
}

// MARK: Favourites

extension WeatherViewModel {
    func updateFavourites() {
        guard let currentWeatherFavourite = currentWeatherFavourite, let favourites = favourites else { return }
        if favourites.contains(currentWeatherFavourite) {
            favourites.remove(currentWeatherFavourite)
        } else {
            favourites.add(currentWeatherFavourite)
        }
        updateIcon()
    }
    
    func updateIcon() {
        guard let currentWeatherFavourite = currentWeatherFavourite, let favourites = favourites else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.containsFavourite = favourites.contains(currentWeatherFavourite)
        }
    }
    
    var currentWeatherFavourite: FavouritesWeatherModel? {
        guard let currentWeather = currentWeather, let location = location else { return nil }
        var favouriteName = currentWeather.name
        if favouriteName.isEmpty {
            favouriteName = "Lat:\(location.latitude) Lon: \(location.longitude)"
        }
        return FavouritesWeatherModel(id: currentWeather.id, name: favouriteName, location: location)
    }
}

