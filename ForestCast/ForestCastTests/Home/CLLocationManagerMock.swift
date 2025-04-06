//
//  CLLocationManagerMock.swift
//  ForestCast
//
//  Created by Marie Harmsen on 06/04/2025.
//

@testable import ForestCast
import CoreLocation

class CLLocationManagerMock: CLLocationManager {
    
    var mockAuthizationStatus: CLAuthorizationStatus = .denied
    
    override var authorizationStatus: CLAuthorizationStatus {
        return mockAuthizationStatus
    }

}
