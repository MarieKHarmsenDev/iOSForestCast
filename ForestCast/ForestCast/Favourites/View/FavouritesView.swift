//
//  FavouritesView.swift
//  ForestCast
//
//  Created by Marie Harmsen on 06/04/2025.

import SwiftUI

struct FavouritesView: View {
    @StateObject private var viewModel = FavourtiesViewModel()
    
    var body: some View {
        VStack {
            if viewModel.favourites.isEmpty {
                Spacer()
                emptyFavourites
            } else {
                favouritesListView
            }
            Spacer()
        }
        .navigationTitle("Test")
        .onAppear {
            viewModel.fetchFavourites()
        }
    }
    
    var favouritesListView: some View {
        NavigationView {
            VStack {
                Title2(text: "favourites.heading".localized, color: .black)
                List() {
                    ForEach(viewModel.favourites) { favourite in
                        NavigationLink(favourite.name,
                                       destination: WeatherView(viewModel: WeatherViewModel(location: Location(latitude: favourite.location.latitude, longitude: favourite.location.longitude),
                                                                                            shouldShowFavourites: false,
                                                                                            network: WeatherNetworkManager(todaysDate: Date()))))
                    }
                    .onDelete(perform: removeRows)
                }
            }
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        for index in offsets {
            viewModel.deleteFavourite(favourite: viewModel.favourites[index])
        }
    }
    
    var emptyFavourites: some View {
        VStack {
            Title2(text: "favourites.heading".localized, color: .black)
            Spacer()
            Regular(text: "favourites.noFavourites".localized, color: .black)
            Spacer()
        }
    }
}

#Preview {
    FavouritesView()
}

