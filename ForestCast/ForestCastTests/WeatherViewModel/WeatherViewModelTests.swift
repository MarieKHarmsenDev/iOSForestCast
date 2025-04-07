//
//  HomeViewModelTests.swift
//  ForestCast
//
//  Created by Marie Harmsen on 05/04/2025.
//

import Testing
import ForestCast
import UIKit
import XCTest
import SwiftUI
@testable import ForestCast

class WeatherViewModelTests: XCTestCase {
    
    var sut: WeatherViewModel!
    
    private let currentFavourite = FavouritesWeatherModel(id: 1, name: "Johannesburg", location: Location(latitude: 1, longitude: 2))
    
    func createSUT(type: WeatherType) -> WeatherViewModel {
        return WeatherViewModel(location: Location(latitude: 11.1, longitude: 12.2),
                                network: WeatherNetworkManagerMock(weatherType: type))
    }
    
    func testClearWeather_textAndColor() {
        let sut = createSUT(type: .clear)
        XCTAssertEqual(sut.backgroundColor, Color.sunny)
        XCTAssertEqual(sut.descriptionLocalized, "SUNNY")
    }
    
    func testCloudyWeather_textAndColor() {
        let sut = createSUT(type: .clouds)
        XCTAssertEqual(sut.backgroundColor, Color.cloudy)
        XCTAssertEqual(sut.descriptionLocalized, "CLOUDY")
    }
    
    func testRainyWeather_textAndColor() {
        let sut = createSUT(type: .rain)
        XCTAssertEqual(sut.backgroundColor, Color.rainy)
        XCTAssertEqual(sut.descriptionLocalized, "RAINY")
    }

}
