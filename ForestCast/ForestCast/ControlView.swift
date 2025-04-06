//
//  ControlView.swift
//  ForestCast
//
//  Created by Marie Harmsen on 06/04/2025.
//

import SwiftUI

struct ControlView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView()
            }
            Tab("Favourites", systemImage: "star") {
                FavouritesView()
            }
        }
        .onAppear() {
            UITabBar.appearance().backgroundColor = .white
        }
    }
}
