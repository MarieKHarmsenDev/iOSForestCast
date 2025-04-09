//
//  HomeNetworkManagerTests.swift
//  ForestCastTests
//
//  Created by Marie Harmsen on 03/04/2025.
//

import Testing
import ForestCast
import UIKit
import XCTest
import SwiftUI
@testable import ForestCast
import CoreLocation

enum ResponseType {
    case success
    case failure
}

class HomeViewModelTests: XCTestCase {
    
    var sut: HomeViewModel!
    var locationManager = CLLocationManagerMock()
    
    override func setUp() {
        super.setUp()
        sut = createSUT(response: .success)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func createSUT(response: ResponseType) -> HomeViewModel {
        return HomeViewModel(locationManager: locationManager,
                             network: HomeNetworkManagerMock(responseType: response))
    }
    
    func testCouldNotRetrieveAPIKey() {
        sut = createSUT(response: .failure)
        XCTAssertTrue(sut.shouldShowError)
    }
    
    func testAPIKeyRetrieved() {
        let locationMock = CLLocation(latitude: 52.1, longitude: 53.1)
        locationManager.delegate?.locationManager?(locationManager, didUpdateLocations: [locationMock])
        XCTAssertTrue(sut.hasFetchedKey)
        XCTAssertNotNil(LocationValuesManager.shared.latitude)
        XCTAssertNotNil(LocationValuesManager.shared.longitude)
        XCTAssertNotNil(KeyManager.shared.getAPIKey())
        XCTAssertTrue(sut.hasFetchedLocation)
    }
    
    func testGoogleAPIKeyRetrieved() {
        let locationMock = CLLocation(latitude: 52.1, longitude: 53.1)
        XCTAssertNotNil(KeyManager.shared.getGoogleAPIKey())
    }
}
