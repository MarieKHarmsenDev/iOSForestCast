//
//  HomeView.swift
//  ForestCast
//
//  Created by Marie Harmsen on 03/04/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        if viewModel.shouldShowError {
            ErrorView()
        } else if viewModel.isLoading {
            LoadingView()
        } else if let apiKey = viewModel.apiKey, let latitude = viewModel.latitude, let longitude = viewModel.longitude {
            WeatherView(viewModel: WeatherViewModel(apiKey: apiKey,
                                                    location: Location(latitude: latitude,
                                                                       longitude: longitude),
                                                    network: WeatherNetworkManager()))
        }
    }
}

#Preview {
    HomeView()
}
