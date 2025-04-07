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

    private var locationManager: CLLocationManager?
    private var network: HomeNetworkManagerProtocol?
    private let networkLogger = NetworkLogger()
    @Published var shouldShowError: Bool = false
    @Published var isLoading: Bool = true
    @Published var shouldShowAlert: Bool = false
    var latitude: Double?
    var longitude: Double?
        
    init(locationManager: CLLocationManager, network: HomeNetworkManagerProtocol) {
        super.init()
        self.network = network
        self.locationManager = locationManager
        locationManager.delegate = self
        fetchAPIKey()
    }
    
    private func fetchAPIKey() {
        network?.fetchAPIWeatherKey { [weak self] result in
            switch result {
            case .success(let apiKey):
                KeyManager.shared.setApiKey(key: apiKey)
                self?.getUserLocation()
                self?.isLoading = false
            case .failure(let error):
                self?.networkLogger.logError("API Key error \(error)")
                self?.shouldShowError = true
            }
        }
    }
    
    private func getUserLocation() {
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    private func isLocationAuthorised() {
        switch locationManager?.authorizationStatus {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            shouldShowAlert = true
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
        default:
            locationManager?.requestWhenInUseAuthorization()
        }
    }
}

extension HomeViewModel: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        isLocationAuthorised()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager?.stopUpdatingLocation()
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
    }
}
