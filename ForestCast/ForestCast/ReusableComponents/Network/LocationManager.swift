//
//  LocationManager.swift
//  ForestCast
//
//  Created by Marie Harmsen on 08/04/2025.
//
struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

class LocationValuesManager {
    static var shared = LocationValuesManager()
    
    private init() {}
    
    var location: Location = Location(latitude: 0, longitude: 0)
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    func setLocation(location: Location) {
        self.latitude = location.latitude
        self.longitude = location.longitude
        
        self.location = location
    }
    
}
