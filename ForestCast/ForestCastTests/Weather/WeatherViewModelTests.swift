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
    
    private let johannesburgFavourite = FavouritesWeatherModel(id: 1, name: "Johannesburg", location: Location(latitude: 12.1, longitude: 13.2))
    private let londonFavourite = FavouritesWeatherModel(id: 2, name: "London", location: Location(latitude: 12.1, longitude: 13.2))
    private let tokyoFavourite = FavouritesWeatherModel(id: 3, name: "Tokyo", location: Location(latitude: 50, longitude: 100))
    
    override func setUp() {
        super.setUp()
        sut = createSUT()
        sut.fetchData()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testClearWeather_textAndColor() {
        sut = createSUT(type: .clear)
        sut.fetchData()

        XCTAssertEqual(sut.backgroundColor, Color.sunny)
        XCTAssertEqual(sut.descriptionLocalized, "SUNNY")
    }
    
    func testCloudyWeather_textAndColor() {
        sut = createSUT(type: .clouds)
        sut.fetchData()

        XCTAssertEqual(sut.backgroundColor, Color.cloudy)
        XCTAssertEqual(sut.descriptionLocalized, "CLOUDY")
    }
    
    func testRainyWeather_textAndColor() {
        sut = createSUT(type: .rain)
        sut.fetchData()

        XCTAssertEqual(sut.backgroundColor, Color.rainy)
        XCTAssertEqual(sut.descriptionLocalized, "RAINY")
    }
    
    func testUpdateFavourites_addFavourite() {
        sut = createSUT(isNewFavourite: true)
        sut.fetchData()
                
        if let fav = sut.favourites, let currentFav = sut.currentWeatherFavourite {
            XCTAssertFalse(fav.contains(currentFav))
        } else {
            XCTFail()
        }
        
        sut.updateFavourites()
        
        XCTAssertEqual(sut.favourites?.getFavouriteLocations().count, 3)
        XCTAssertEqual(sut.favourites?.getFavouriteLocations(), [johannesburgFavourite, londonFavourite, tokyoFavourite])
    }
    
    func testUpdateFavourites_UpdateIcon_removeFavourite() {
        sut = createSUT()
        sut.fetchData()
                
        if let fav = sut.favourites, let currentFav = sut.currentWeatherFavourite {
            XCTAssertTrue(fav.contains(currentFav))
        } else {
            XCTFail()
        }
        
        sut.updateFavourites()

        XCTAssertEqual(sut.favourites?.getFavouriteLocations().count, 1)
        XCTAssertEqual(sut.favourites?.getFavouriteLocations(), [londonFavourite])
        XCTAssertFalse(sut.containsFavourite)
    }
    
    func testUpdateIcon_containsFavourite() {
        sut = createSUT()
        
        sut.updateIcon()

        XCTAssertFalse(sut.containsFavourite)
    }
    
    func testUpdateIcon_doesNotContainFavourite() {
        sut = createSUT(isNewFavourite: true)
        
        sut.updateIcon()

        XCTAssertFalse(sut.containsFavourite)
    }
    
    func testCurrentWeatherFavourite() {
        sut = createSUT()
        sut.fetchData()

        XCTAssertEqual(sut.currentWeatherFavourite?.name, "Johannesburg")
        XCTAssertEqual(sut.currentWeatherFavourite?.id, 1)
        XCTAssertEqual(sut.currentWeatherFavourite?.location, Location(latitude: 50, longitude: 100))
    }
    
    func testFetchData_FailedResponse() {
        sut = createSUT(responseType: .failure)
        
        sut.fetchData()

        let expectation = self.expectation(description: "main thread updated")
        DispatchQueue.main.async {
            XCTAssertTrue(true)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(sut.shouldShowError)
    }

}

extension WeatherViewModelTests {
    func createSUT(type: WeatherType = .clear, responseType: ResponseType = .success, isNewFavourite: Bool = false) -> WeatherViewModel {
        return WeatherViewModel(location: Location(latitude: 50, longitude: 100),
                                network: WeatherNetworkManagerMock(weatherType: type,
                                                                   responseType: responseType,
                                                                   isNewFavourite: isNewFavourite),
                                favourites: FavouritesManagerMock(currentFavourites: [johannesburgFavourite, londonFavourite]))
    }
}
