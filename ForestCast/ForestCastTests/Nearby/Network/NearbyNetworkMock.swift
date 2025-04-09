//
//  NearbyNetworkMock.swift
//  ForestCast
//
//  Created by Marie Harmsen on 09/04/2025.
//

@testable import ForestCast

class NearbyNetworkManagerMock: NearbyNetworkManagerProtocol {
    
    private var responseType: ResponseType
    
    init(responseType: ResponseType) {
        self.responseType = responseType
    }
    
    func fetchNearbyPlaces(completion: @escaping (Result<[ForestCast.Place], ForestCast.NetworkError>) -> Void) {
        switch responseType {
        case .success:
            return completion(.success([Place(name: "Woking Park")]))
        case .failure:
            return completion(.failure(.noData))
        }
    }
}
