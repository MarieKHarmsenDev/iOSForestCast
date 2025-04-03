//
//  ContentView.swift
//  ForestCast
//
//  Created by Marie Harmsen on 03/04/2025.
//

import SwiftUI

struct HomeView: View {
    private let viewModel = HomeViewModel()
    private let isIPad = UIDevice.current.userInterfaceIdiom == .pad
    
    var body: some View {
        VStack {
            topImage
                .padding(.bottom, 8)
            currentWeatherInfo
            Divider()
                .frame(height: 2)
                .background(Color.white)
                .padding(.bottom, 16)
            dailyWeatherInfo
            Spacer()
        }
        .background(viewModel.backgroundColor)
    }
    
    private var topImage: some View {
        Image("sunny")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipped()
            .ignoresSafeArea()
            .frame(maxHeight: isIPad ? 800 : 300)
            .overlay(
                VStack(spacing: 8) {
                    Title1(text: "25°")
                        .padding(.top, 24)
                    Title2(text: "Sunny")
                }, alignment: .top)
    }
    
    private var currentWeatherInfo: some View {
        HStack {
            weatherColumn(temp: "19", description: "min")
                .padding(.leading)
            Spacer()
            weatherColumn(temp: "25", description: "Current")
            Spacer()
            weatherColumn(temp: "27", description: "max")
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
            ForEach(HomeViewModel.DaysOfWeek.allCases, id: \.self) { day in
                weatherRow(day: day.rawValue, iconName: "clearIcon", temp: "20")
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

#Preview {
    HomeView()
}
