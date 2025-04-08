//
//  FavouritesView.swift
//  ForestCast
//
//  Created by Marie Harmsen on 06/04/2025.

import SwiftUI
import _MapKit_SwiftUI

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
        .onAppear {
            viewModel.fetchFavourites()
        }
    }
    
    private var favouritesListView: some View {
        NavigationView {
            VStack {
                Title2(text: "favourites.heading".localized, color: .black)
                favouritesMap
                favouritesList
            }
            .navigationTitle("favourites.title".localized)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var favouritesMap: some View {
        Map(position: $viewModel.position, selection: $viewModel.selectedItem) {
            ForEach(viewModel.favourites) { destination in
                Marker(destination.name, coordinate: destination.coordinates)
                    .tint(Color.tint)
            }
        }.mapControls {
            MapUserLocationButton()
        }
    }
    
    private var favouritesList: some View {
        List() {
            ForEach(viewModel.favourites) { favourite in
                NavigationLink(favourite.name,
                               destination: WeatherView(viewModel: WeatherViewModel(location: favourite.location, shouldShowFavourites: false,
                                                                                    network: WeatherNetworkManager(todaysDate: Date()))))
            }
            .onDelete(perform: removeRows)
        }
    }
    
    private func removeRows(at offsets: IndexSet) {
        for index in offsets {
            viewModel.deleteFavourite(favourite: viewModel.favourites[index])
        }
    }
    
    private var emptyFavourites: some View {
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

