//
//  FavouritesManagerMock.swift
//  ForestCast
//
//  Created by Marie Harmsen on 08/04/2025.
//
import Testing
import ForestCast
import UIKit
import XCTest
import SwiftUI
@testable import ForestCast

class FavouritesManagerMock: FavouritesManagerProtocol {
    
    private var currentFavourites = [FavouritesWeatherModel]()
    
    init(currentFavourites: [FavouritesWeatherModel]) {
        self.currentFavourites = currentFavourites
    }
    
    func getFavouriteLocations() -> [ForestCast.FavouritesWeatherModel] {
        return currentFavourites
    }
    
    func contains(_ location: ForestCast.FavouritesWeatherModel) -> Bool {
        currentFavourites.contains(where: {$0.id == location.id})
    }
    
    func add(_ location: ForestCast.FavouritesWeatherModel) {
        currentFavourites.append(location)
    }
    
    func remove(_ location: ForestCast.FavouritesWeatherModel) {
        currentFavourites.removeAll { $0.id == location.id }
    }
    
}
