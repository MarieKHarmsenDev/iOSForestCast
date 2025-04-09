//
//  FavouritesWeatherModel.swift
//  ForestCast
//
//  Created by Marie Harmsen on 07/04/2025.
//

import MapKit

struct FavouritesWeatherModel: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let location: Location
    
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
}
