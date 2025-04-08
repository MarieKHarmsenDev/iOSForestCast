//
//  NearbyPlacesModel.swift
//  ForestCast
//
//  Created by Marie Harmsen on 08/04/2025.
//

import Foundation

struct NearbyPlacesModel: Codable {
    let results: [Place]
}

struct Place: Codable, Hashable {
    let name: String
}
