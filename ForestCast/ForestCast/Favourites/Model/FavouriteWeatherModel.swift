//
//  FavouriteWeatherModel.swift
//  ForestCast
//
//  Created by Marie Harmsen on 07/04/2025.
//

struct FavouritesWeatherModel: Codable, Identifiable {
    let id: Int
    let name: String
    let location: Location
}
