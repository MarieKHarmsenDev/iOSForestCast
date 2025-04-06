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

enum ResponseType {
    case success
    case failure
}

class HomeViewModelTests: XCTestCase {
    
    var sut: HomeViewModel!
    
    func createSUT(response: ResponseType) -> HomeViewModel {
        return HomeViewModel(network: HomeNetworkManagerMock(responseType: response))
    }
    
    func testCouldNotRetrieveAPIKey() {
        sut = createSUT(response: .failure)
        XCTAssertTrue(sut.shouldShowError)
    }

}
