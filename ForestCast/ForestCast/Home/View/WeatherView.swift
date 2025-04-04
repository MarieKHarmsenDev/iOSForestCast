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
               let tempCurrent = viewModel?.currentWeather?.tempString,
               let description = viewModel?.descriptionLocalized {
                topImage(imageName: imageName, temp: tempCurrent, description: description)
                    .padding(.bottom, 8)
            }
            if let tempMin = viewModel?.currentWeather?.tempMinString,
               let tempCurrent = viewModel?.currentWeather?.tempString,
               let tempMax = viewModel?.currentWeather?.tempMaxString {
                currentWeatherInfo(tempMin: tempMin,
                                   tempCurrent: tempCurrent,
                                   tempMax: tempMax)
            }
            Divider()
                .frame(height: 2)
                .background(Color.white)
                .padding(.bottom, 16)
            dailyWeatherInfo
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
    
    private func currentWeatherInfo(tempMin: String, tempCurrent: String, tempMax: String) -> some View {
        HStack {
            weatherColumn(temp: tempMin, description: "weatherScreen.min".localized)
                .padding(.leading)
            Spacer()
            weatherColumn(temp: tempCurrent, description: "weatherScreen.current".localized)
            Spacer()
            weatherColumn(temp: tempMax, description: "weatherScreen.max".localized)
                .padding(.trailing)
        }
    }
    
    private func weatherColumn(temp: String, description: String) -> some View {
        VStack {
            RegularBold(text: temp + "°")
            Regular(text: description)
        }
    }
    
    private var dailyWeatherInfo: some View {
        VStack(spacing: 16) {
            //ForEach(HomeViewModel.DaysOfWeek.allCases, id: \.self) { day in
             //   weatherRow(day: day.rawValue, iconName: "clearIcon", temp: "20")
          //  }
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

#Preview {
    WeatherView(viewModel: WeatherViewModel(currentWeather: CurrentWeatherModel(temp: 12.1, tempMin: 12.2, tempMax: 112.3, weatherType: .clouds)))
}
