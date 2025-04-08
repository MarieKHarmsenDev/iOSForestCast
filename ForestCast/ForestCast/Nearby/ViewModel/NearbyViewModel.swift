//
//  NearbyViewModel.swift
//  ForestCast
//
//  Created by Marie Harmsen on 08/04/2025.
//

import SwiftUI
import Foundation

class NearbyViewModel: NSObject, ObservableObject {

    private var network: NearbyNetworkManagerProtocol?
    private let networkLogger = NetworkLogger()
    @Published var hasFetchedData: Bool = false
    @Published var shouldShowError: Bool = false
    @Published var places: [Place]?
        
    init(network: NearbyNetworkManagerProtocol) {
        super.init()
        self.network = network
    }
    
    func fetchNearbyData() {
        network?.fetchNearbyPlaces { [weak self] result in
            switch result {
            case .success(let nearbyPlaces):
                DispatchQueue.main.async {
                    self?.hasFetchedData = true
                    self?.places = nearbyPlaces
                }
            case .failure(_):
                self?.shouldShowError = true
            }
        }
    }
    
}
