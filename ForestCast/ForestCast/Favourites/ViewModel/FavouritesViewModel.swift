//
//  FavouritesViewModel.swift
//  ForestCast
//
//  Created by Marie Harmsen on 07/04/2025.
//
import SwiftUI

class FavourtiesViewModel: NSObject, ObservableObject {
    private var favouritesManager = FavouritesManager()
    @Published var favourites: [FavouritesWeatherModel] = []
    
    func fetchFavourites() {
        favourites = favouritesManager.getFavouriteLocations()
    }
    
    func deleteFavourite(favourite: FavouritesWeatherModel?) {
        guard let favourite = favourite else { return }
        favouritesManager.remove(favourite)
    }
}
