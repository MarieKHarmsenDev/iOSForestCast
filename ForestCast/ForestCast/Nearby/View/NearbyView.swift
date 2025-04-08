//
//  NearbyView.swift
//  ForestCast
//
//  Created by Marie Harmsen on 08/04/2025.
//

import SwiftUI

struct NearbyView: View {
    
    @StateObject var viewModel = NearbyViewModel(network: NearbyNetworkManager())
    
    var body: some View {
        VStack {
            if viewModel.shouldShowError {
                ErrorView()
            } else if viewModel.hasFetchedData {
                NearbyContentView(viewModel: viewModel)
            } else {
                LoadingView()
            }
        }
        .onAppear(perform: {
            viewModel.fetchNearbyData()
        })
    }
}

struct NearbyContentView: View {
    
    private let viewModel: NearbyViewModel?
    
    init(viewModel: NearbyViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Title2(text: "nearby.Parks".localized, color: .black)
        List() {
            if let places = viewModel?.places {
                ForEach(places, id: \.self) { place in
                    Regular(text: place.name, color: .black)
                }
            }
        }
    }
}


#Preview {
    NearbyView()
}
