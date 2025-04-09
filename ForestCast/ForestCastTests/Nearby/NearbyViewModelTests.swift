//
//  NearbyViewModelTests.swift
//  ForestCast
//
//  Created by Marie Harmsen on 09/04/2025.
//

import Testing
import ForestCast
import UIKit
import XCTest
import SwiftUI
@testable import ForestCast

class NearbyViewModelTests: XCTestCase {
    
    var sut: NearbyViewModel!
    
    override func setUp() {
        super.setUp()
        sut = NearbyViewModel(network: NearbyNetworkManagerMock(responseType: .success))
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testFetchData_success() {
        let expectation = self.expectation(description: "main thread updated")
        sut = NearbyViewModel(network: NearbyNetworkManagerMock(responseType: .success))
        sut.fetchNearbyData()
        DispatchQueue.main.async {
            XCTAssertTrue(true)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(sut.hasFetchedData)
        XCTAssertEqual(sut.places, [Place(name: "Woking Park")])
    }
    
    func testFetchData_failure() {
        sut = NearbyViewModel(network: NearbyNetworkManagerMock(responseType: .failure))
        sut.fetchNearbyData()
        XCTAssertTrue(sut.shouldShowError)
        XCTAssertFalse(sut.hasFetchedData)
        XCTAssertNil(sut.places)
    }
}
