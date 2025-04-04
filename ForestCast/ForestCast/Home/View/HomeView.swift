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
        if let currentWeather = viewModel.currentWeather {
            WeatherView(viewModel: WeatherViewModel(currentWeather: currentWeather))
        } else {
            LoadingView()
        }
    }
}

#Preview {
    HomeView()
}
