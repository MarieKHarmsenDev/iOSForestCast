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
        } else if let currentWeather = viewModel.currentWeather,
           let forecastWeather = viewModel.forecastWeather {
            WeatherView(viewModel: WeatherViewModel(currentWeather: currentWeather, forecastWeather: forecastWeather))
        } else {
            LoadingView()
        }
    }
}

#Preview {
    HomeView()
}
