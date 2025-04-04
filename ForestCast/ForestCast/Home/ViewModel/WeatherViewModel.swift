//
//  WeatherViewModel.swift
//  ForestCast
//
//  Created by Marie Harmsen on 04/04/2025.
//
import SwiftUI

class WeatherViewModel: NSObject, ObservableObject {
    
    var currentWeather: CurrentWeatherModel?
    
    init(currentWeather: CurrentWeatherModel) {
        super.init()
        self.currentWeather = currentWeather
    }
    
    var backgroundColor: Color {
        switch currentWeather?.weatherType {
        case .clear:
            return Color.sunny
        case .clouds:
            return Color.cloudy
        case .rainy:
            return Color.rainy
        case .none:
            return Color.black
        }
    }
    
    var descriptionLocalized: String {
        switch currentWeather?.weatherType {
        case .clear:
            return "weatherScreen.sunny".localized
        case .clouds:
            return "weatherScreen.cloudy".localized
        case .rainy:
            return "weatherScreen.rainy".localized
        case .none:
            return ""
        }
    }
}

