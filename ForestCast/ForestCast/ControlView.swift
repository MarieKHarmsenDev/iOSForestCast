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
            Tab("tab.Home".localized, systemImage: "house") {
                HomeView()
            }
            Tab("tab.Favourites".localized, systemImage: "heart.fill") {
                FavouritesView()
            }
            Tab("tab.Nearby".localized, systemImage: "location") {
                NearbyView()
            }
        }
        .tint(Color.tint)
        .onAppear() {
            UITabBar.appearance().backgroundColor = .white
        }
    }
}
