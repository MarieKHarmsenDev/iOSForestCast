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
    var shouldShowFavourites: Bool = false
    private var network: WeatherNetworkManagerProtocol?
    
    private var networkLogger = NetworkLogger()
    private var favourites = FavouritesManager()

    var currentWeather: CurrentWeatherModel?
    var forecastWeather: ForecastWeatherModel?
    var currentLocationAsFavourite: FavouritesWeatherModel?

    @Published var shouldShowError = false
    @Published var isLoading = true
    @Published var containsFavourite: Bool = false
    
    init(location: Location? = Location(latitude: LocationValuesManager.shared.latitude, longitude: LocationValuesManager.shared.longitude),
         shouldShowFavourites: Bool = true,
         network: WeatherNetworkManagerProtocol) {
        super.init()
        self.location = location
        self.network = network
        self.shouldShowFavourites = shouldShowFavourites
        fetchData()
    }
    
    private func fetchData() {
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
                guard let weather = weather else { return }
                var name = weather.name
                if name.isEmpty {
                    name = "Lat:\(location.latitude) Lon: \(location.longitude)"
                }
                self?.currentLocationAsFavourite = FavouritesWeatherModel(id: weather.id,
                                                                          name: name,
                                                                          location: location)
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
    
    func updateFavourites() {
        guard let currentLocationAsFavourite = currentLocationAsFavourite else { return }
        if favourites.contains(currentLocationAsFavourite) {
            favourites.remove(currentLocationAsFavourite)
        } else {
            favourites.add(currentLocationAsFavourite)
        }
        updateIcon()
    }
    
    func updateIcon() {
        guard let currentLocationAsFavourite = currentLocationAsFavourite else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.containsFavourite = favourites.contains(currentLocationAsFavourite)
        }
    }
}
