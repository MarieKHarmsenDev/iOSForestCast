//
//  WeatherNetworkManagerTests.swift
//  ForestCast
//
//  Created by Marie Harmsen on 06/04/2025.
//

import Testing
import ForestCast
import UIKit
import XCTest
import SwiftUI
@testable import ForestCast

class WeatherNetworkManagerTests: XCTestCase {
    
    var sut: WeatherNetworkManager!
    private var fileReader = FileReader()
    
    // MARK: CurrentWeather
    
    override func setUp() {
        let specificDate = Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 5))
        sut = WeatherNetworkManager(todaysDate: specificDate!)
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testfetchCurrentWeatherData_malformedURL() {
        sut.fetchCurrentWeatherData(lat: "<>", long: "") { result in
            switch result {
            case .success(_):
                XCTFail("This should fail due to invalid characters in URL")
            case .failure(let error):
                XCTAssertEqual(error, .malformedURL)
            }
        }
    }
    
    func testDecodeCurrentWeatherData() {
        guard let data = fileReader.readJSONFile(fileName: "CurrentWeather") else {
            XCTFail("Data issue")
            return
        }
        let expectedResult = CurrentWeatherModel(temperature: 19.0, temperatureMin: 18.48, temperatureMax: 20.81, weatherType: .clear, name: "Abbey Wood", id: 7302135)
        let result = sut.decodeCurrentWeatherData(data)
        XCTAssertEqual(result, expectedResult)
    }
    
    // MARK: ForecastWeather

    func testfetchForecastWeatherData_malformedURL() {
        sut.fetchForecastWeatherData(lat: "<>", long: "") { result in
            switch result {
            case .success(_):
                XCTFail("This should fail due to invalid characters in URL")
            case .failure(let error):
                XCTAssertEqual(error, .malformedURL)
            }
        }
    }
    
    func testDecodeForecastWeatherData_at6pm() {
        guard let data = fileReader.readJSONFile(fileName: "ForecastWeather") else {
            XCTFail("Data issue")
            return
        }
        let forecastDayOne = ForecastDays(date: "2025-04-06 18:00:00", dateInterval: 1743962400, temprature: 9.31, weatherType: .clouds)
        let forecastDayTwo = ForecastDays(date: "2025-04-07 18:00:00", dateInterval: 1744048800, temprature: 10.18, weatherType: .clear)
        let forecastDayThree = ForecastDays(date: "2025-04-08 18:00:00", dateInterval: 1744135200, temprature: 10.58, weatherType: .clear)
        let forecastDayFour = ForecastDays(date: "2025-04-09 18:00:00", dateInterval: 1744221600, temprature: 11.09, weatherType: .clouds)
        let forecastDayFive = ForecastDays(date: "2025-04-10 18:00:00", dateInterval: 1744308000, temprature: 11.42, weatherType: .clouds)
        
        let allForecastDays = [forecastDayOne, forecastDayTwo, forecastDayThree, forecastDayFour, forecastDayFive]
        let expectedResult = ForecastWeatherModel(forecastDays: allForecastDays)
        let result = sut.decodeForecastWeatherData(data, currentHour: 18)
        XCTAssertEqual(result, expectedResult)
    }
    
    func testDecodeForecastWeatherData_at4pm_showClosestWeatherInfo() {
        guard let data = fileReader.readJSONFile(fileName: "ForecastWeather") else {
            XCTFail("Data issue")
            return
        }
        let forecastDayOne = ForecastDays(date: "2025-04-06 15:00:00", dateInterval: 1743951600, temprature: 11.67, weatherType: .clouds)
        let forecastDayTwo = ForecastDays(date: "2025-04-07 15:00:00", dateInterval: 1744038000, temprature: 13.63, weatherType: .clear)
        let forecastDayThree = ForecastDays(date: "2025-04-08 15:00:00", dateInterval: 1744124400, temprature: 14.54, weatherType: .clouds)
        let forecastDayFour = ForecastDays(date: "2025-04-09 15:00:00", dateInterval: 1744210800, temprature: 14.89, weatherType: .clouds)
        let forecastDayFive = ForecastDays(date: "2025-04-10 15:00:00", dateInterval: 1744297200, temprature: 17.15, weatherType: .clouds)
        
        let allForecastDays = [forecastDayOne, forecastDayTwo, forecastDayThree, forecastDayFour, forecastDayFive]
        let expectedResult = ForecastWeatherModel(forecastDays: allForecastDays)
        let result = sut.decodeForecastWeatherData(data, currentHour: 16)
        XCTAssertEqual(result, expectedResult)
    }
    
    func testDecodeForecastWeatherData_noDataForCurrentDay() {
        guard let data = fileReader.readJSONFile(fileName: "ForecastWeatherNoDataForToday") else {
            XCTFail("Data issue")
            return
        }
        let specificDate6April = Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 6))
        let sutNoData = WeatherNetworkManager(todaysDate: specificDate6April!)

        let forecastDayOne = ForecastDays(date: "2025-04-07 15:00:00", dateInterval: 1744038000, temprature: 12.59, weatherType: .clear)
        let forecastDayTwo = ForecastDays(date: "2025-04-08 15:00:00", dateInterval: 1744124400, temprature: 14.2, weatherType: .clear)
        let forecastDayThree = ForecastDays(date: "2025-04-09 15:00:00", dateInterval: 1744210800, temprature: 14.69, weatherType: .clear)
        let forecastDayFour = ForecastDays(date: "2025-04-10 15:00:00", dateInterval: 1744297200, temprature: 17.32, weatherType: .clear)
        let forecastDayFive = ForecastDays(date: "2025-04-11 15:00:00", dateInterval: 1744383600, temprature: 20.03, weatherType: .clouds)
        
        let allForecastDays = [forecastDayOne, forecastDayTwo, forecastDayThree, forecastDayFour, forecastDayFive]
        let expectedResult = ForecastWeatherModel(forecastDays: allForecastDays)
        let result = sutNoData.decodeForecastWeatherData(data, currentHour: 16)
        XCTAssertEqual(result, expectedResult)
    }
}
