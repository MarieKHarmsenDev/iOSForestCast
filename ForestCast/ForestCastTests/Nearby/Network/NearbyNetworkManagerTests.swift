//
//  NearbyNetworkManagerTests.swift
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

class NearbyNetworkManagerTests: XCTestCase {
    
    var sut: NearbyNetworkManager!
    private var fileReader = FileReader()
        
    override func setUp() {
        sut = NearbyNetworkManager()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testDecodeData() {
        guard let data = fileReader.readJSONFile(fileName: "GooglePlaces") else {
            XCTFail("Data issue")
            return
        }
        let expectedResult = [Place(name: "Coulsdon Common"),
                              Place(name: "South London Downs National Nature Reserve"),
                              Place(name: "Merlewood Estate Office"),
                              Place(name: "Graham\'s Walk"),
                              Place(name: "Betts Mead Recreation Ground")]
        let result = sut.decodePlacesJSON(data: data)
        XCTAssertEqual(result, expectedResult)
    }
}
