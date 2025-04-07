//
//  HomeView.swift
//  ForestCast
//
//  Created by Marie Harmsen on 03/04/2025.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel(locationManager: CLLocationManager(),
                                                       network: HomeNetworkManager())
    
    var body: some View {
        if viewModel.shouldShowError {
            ErrorView()
        } else if viewModel.isLoading {
            LoadingView()
                .alert("locationPermission.alertTitle".localized, isPresented: $viewModel.shouldShowAlert) {
                    Button("locationPermission.alertSettings".localized) {
                        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }
                    Button("locationPermission.alertCancel".localized) {}
                } message: {
                    Regular(text: "locationPermission.alertMessage".localized)
                }
        } else if !viewModel.isLoading, let latitude = viewModel.latitude, let longitude = viewModel.longitude {
            WeatherView(viewModel: WeatherViewModel(location: Location(latitude: latitude,
                                                                       longitude: longitude),
                                                    network: WeatherNetworkManager(todaysDate: Date())))
        }
    }
}

#Preview {
    HomeView()
}
