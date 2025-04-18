//
//  WeatherView.swift
//  ForestCast
//
//  Created by Marie Harmsen on 04/04/2025.
//

import SwiftUI

struct WeatherView: View {
    @StateObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            if viewModel.shouldShowError {
                ErrorView()
            } else if viewModel.isLoading {
                LoadingView()
            } else {
                WeatherContentView(viewModel: viewModel)
            }
        }
        .onAppear{
            viewModel.fetchData()
        }
    }
}

struct WeatherContentView: View {
    private let isIPad = UIDevice.current.userInterfaceIdiom == .pad
    @StateObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            if let imageName = viewModel.currentWeather?.weatherType.rawValue,
               let tempCurrent = viewModel.currentWeather?.temperatureString {
                topImage(imageName: imageName, temp: tempCurrent, description: viewModel.descriptionLocalized)
                    .padding(.bottom, 8)
            }
            if let temperatureMin = viewModel.currentWeather?.temperatureMinString,
               let temperatureCurrent = viewModel.currentWeather?.temperatureString,
               let temperatureMax = viewModel.currentWeather?.temperatureMaxString {
                currentWeatherInfo(temperatureMin: temperatureMin,
                                   temperatureCurrent: temperatureCurrent,
                                   temperatureMax: temperatureMax)
            }
            Divider()
                .frame(height: 2)
                .background(Color.white)
                .padding(.bottom, 16)
            if let forecastdays = viewModel.forecastWeather?.forecastDays {
                dailyWeatherInfo(days: forecastdays)
            }
            if viewModel.shouldShowFavourites {
                favouritesButton
                    .padding()
            }
            Spacer()
        }
        .onAppear {
            viewModel.updateIcon()
        }
        .background(viewModel.backgroundColor)
    }
    
    private func topImage(imageName: String, temp: String, description: String) -> some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipped()
            .accessibilityHidden(true)
            .ignoresSafeArea()
            .frame(maxHeight: isIPad ? 800 : 300)
            .overlay(
                VStack(spacing: 8) {
                    Title1(text: temp)
                        .padding(.top, 24)
                    Title2(text: description)
                }, alignment: .top)
    }
    
    private func currentWeatherInfo(temperatureMin: String, temperatureCurrent: String, temperatureMax: String) -> some View {
        HStack {
            weatherColumn(temperature: temperatureMin, description: "weatherScreen.min".localized)
                .padding(.leading)
            Spacer()
            weatherColumn(temperature: temperatureCurrent, description: "weatherScreen.current".localized)
            Spacer()
            weatherColumn(temperature: temperatureMax, description: "weatherScreen.max".localized)
                .padding(.trailing)
        }
    }
    
    private func weatherColumn(temperature: String, description: String) -> some View {
        VStack {
            RegularBold(text: temperature)
            Regular(text: description)
                .accessibilityElement(children: .contain)
        }
    }
    
    private func dailyWeatherInfo(days: [ForecastDays]) -> some View {
        VStack(spacing: 16) {
            ForEach(days, id: \.self) { day in
                weatherRow(day: day.dayOfWeek,
                           iconName: day.weatherType.rawValue+"Icon",
                           temp: day.temperatureString)
            }
        }
    }
    
    private func weatherRow(day: String, iconName: String, temp: String) -> some View {
        HStack {
            Regular(text: day)
                .padding(.leading)
            Spacer()
            RegularBold(text: temp + "°")
                .padding(.trailing)
        }
        .overlay(
            Image(iconName)
                .resizable()
                .accessibilityHidden(true)
                .frame(width: 24, height: 24),
            alignment: .center)
    }
    
    private var favouritesButton: some View {
        HStack {
            Spacer()
            Button(action : {
                viewModel.updateFavourites()
            }) {
                ZStack {
                    Circle()
                        .fill(viewModel.containsFavourite ? .red : .gray)
                    
                    Image(systemName: "heart")
                        .foregroundColor(.white)
                        .padding(8)
                        .accessibilityHidden(true)
                }
            }
            .frame(width: 44, height: 44)
        }
        .accessibilityLabel("weatherScreen.accessibility.favourites".localized)
    }
}

#Preview {
    WeatherView(viewModel: WeatherViewModel(location: Location(latitude: 123, longitude: 11), shouldShowFavourites: true, network: WeatherNetworkManager(todaysDate: Date()), favourites: FavouritesManager()))
}
