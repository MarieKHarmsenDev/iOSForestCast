//
//  HomeViewModel.swift
//  ForestCast
//
//  Created by Marie Harmsen on 03/04/2025.
//

import SwiftUI
import Foundation
import CoreLocation

class HomeViewModel: NSObject, ObservableObject {

    private var locationManager = CLLocationManager()
    private var network = HomeNetworkManager()
    @Published var currentWeather: CurrentWeatherModel? = nil
    @Published var forecastWeather: ForecastWeatherModel? = nil
        
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func isLocationAuthorised() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("error")
        case .denied:
            print("error a")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
}

extension HomeViewModel: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        isLocationAuthorised()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let currentLatitude = location.coordinate.latitude
            let currentLongitude = location.coordinate.longitude
            network.fetchCurrentWeatherData(lat: String(describing: currentLatitude),
                                            long: String(describing: currentLongitude)) { [weak self] weather in
                DispatchQueue.main.async {
                    self?.currentWeather = weather
                }
            }
            
            network.fetchForecastWeatherData(lat: String(describing: currentLatitude),
                                             long: String(describing: currentLongitude)) { [weak self] forecast in
                DispatchQueue.main.async {
                    self?.forecastWeather = forecast
                }
            }
        }
    }
}
