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
            Title2(text: "favourites.heading".localized, color: .black)
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
    
    var favouritesListView: some View {
        List() {
            ForEach(viewModel.favourites) { favourite in
                Regular(text: favourite.name, color: .black)
            }
            .onDelete(perform: removeRows)
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        for index in offsets {
            viewModel.deleteFavourite(favourite: viewModel.favourites[index])
        }
    }
    
    var emptyFavourites: some View {
        Regular(text: "favourites.noFavourites".localized, color: .black)
    }
}

#Preview {
    FavouritesView()
}

