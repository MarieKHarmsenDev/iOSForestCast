////
////  FavouritesManagerMock.swift
////  ForestCast
////
////  Created by Marie Harmsen on 07/04/2025.
////
//
//@testable import ForestCast
//
//class FavouritesManagerMock: FavouritesProtocol {
//    
//    var favourites = [FavouritesWeatherModel]()
//    
//    func setFavourites(favourites: [FavouritesWeatherModel]) {
//        self.favourites = favourites
//    }
//    
//    func add(_ location: ForestCast.FavouritesWeatherModel) {
//        favourites.append(location)
//    }
//    
//    func contains(_ location: ForestCast.FavouritesWeatherModel) -> Bool {
//        return favourites.contains(where: {$0.id == location.id })
//    }
//    
//    func getFavouriteLocations() -> [ForestCast.FavouritesWeatherModel] {
//        return favourites
//    }
//    
//    func remove(_ location: ForestCast.FavouritesWeatherModel) {
//        favourites.removeLast()
//    }
//    
//}
