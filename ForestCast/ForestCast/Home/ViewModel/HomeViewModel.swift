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
    private var network: HomeNetworkManagerProtocol?
    private let networkLogger = NetworkLogger()
    @Published var shouldShowError: Bool = false
    @Published var isLoading: Bool = true
    var apiKey: String?
    var latitude: Double?
    var longitude: Double?
        
    init(network: HomeNetworkManagerProtocol) {
        super.init()
        self.network = network
        locationManager.delegate = self
        fetchAPIKey()
    }
    
    private func fetchAPIKey() {
        network?.fetchAPIWeatherKey { [weak self] result in
            switch result {
            case .success(let apiKey):
                self?.apiKey = apiKey
                self?.getUserLocation()
            case .failure(let error):
                self?.networkLogger.logError("API Key error \(error)")
                self?.shouldShowError = true
            }
        }
    }
    
    private func getUserLocation() {
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
            locationManager.requestWhenInUseAuthorization()
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
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            isLoading = false
        }
    }
}
