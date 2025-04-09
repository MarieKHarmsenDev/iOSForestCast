//
//  FavouritesManager.swift
//  ForestCast
//
//  Created by Marie Harmsen on 07/04/2025.
//

import SwiftUI

protocol FavouritesManagerProtocol {
    func getFavouriteLocations() -> [FavouritesWeatherModel]
    func contains(_ location: FavouritesWeatherModel) -> Bool
    func add(_ location: FavouritesWeatherModel)
    func remove(_ location: FavouritesWeatherModel)
}

class FavouritesManager: ObservableObject, FavouritesManagerProtocol {
    private let key = "Favourites"
        
    func getFavouriteLocations() -> [FavouritesWeatherModel] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let locations = try? JSONDecoder().decode([FavouritesWeatherModel].self, from: data) else {
            return []
        }
        return locations
    }
    
    func contains(_ location: FavouritesWeatherModel) -> Bool {
        let favourites = getFavouriteLocations()
        return favourites.contains { $0.id == location.id }
    }
    
    func add(_ location: FavouritesWeatherModel) {
        var favourites = getFavouriteLocations()
        favourites.append(location)
        save(favourites: favourites)
    }
    
    func remove(_ location: FavouritesWeatherModel) {
        var favourites = getFavouriteLocations()
        favourites.removeAll { $0.id == location.id }
        save(favourites: favourites)
    }
    
    private func save(favourites: [FavouritesWeatherModel]) {
        if let encodeData = try? JSONEncoder().encode(favourites) {
            UserDefaults.standard.set(encodeData, forKey: key)
        }
    }
}
