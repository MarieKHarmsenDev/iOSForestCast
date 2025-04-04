//
//  WeatherView.swift
//  ForestCast
//
//  Created by Marie Harmsen on 04/04/2025.
//

import SwiftUI

struct WeatherView: View {
    private let isIPad = UIDevice.current.userInterfaceIdiom == .pad
    private var viewModel: WeatherViewModel?
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            if let imageName = viewModel?.currentWeather?.weatherType.rawValue,
               let tempCurrent = viewModel?.currentWeather?.temperatureString,
               let description = viewModel?.descriptionLocalized {
                topImage(imageName: imageName, temp: tempCurrent, description: description)
                    .padding(.bottom, 8)
            }
            if let temperatureMin = viewModel?.currentWeather?.temperatureMinString,
               let temperatureCurrent = viewModel?.currentWeather?.temperatureString,
               let temperatureMax = viewModel?.currentWeather?.temperatureMaxString {
                currentWeatherInfo(temperatureMin: temperatureMin,
                                   temperatureCurrent: temperatureCurrent,
                                   temperatureMax: temperatureMax)
            }
            Divider()
                .frame(height: 2)
                .background(Color.white)
                .padding(.bottom, 16)
            if let forecastdays = viewModel?.ForecastWeather?.forecastDays {
                dailyWeatherInfo(days: forecastdays)
            }
            Spacer()
        }
        .background(viewModel?.backgroundColor)
    }
    
    private func topImage(imageName: String, temp: String, description: String) -> some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipped()
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
        }
    }
    
    private func dailyWeatherInfo(days: [ForecastDays]) -> some View {
        VStack(spacing: 16) {
            ForEach(0..<5, id: \.self) { index in
                weatherRow(day: days[index].dayOfWeek,
                           iconName: days[index].weatherType.rawValue+"Icon",
                           temp: days[index].temperatureString)
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
                .frame(width: 24, height: 24),
            alignment: .center)
    }
}
