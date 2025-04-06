//
//  HomeNetworkManagerMock.swift
//  ForestCast
//
//  Created by Marie Harmsen on 06/04/2025.
//

@testable import ForestCast

class HomeNetworkManagerMock: HomeNetworkManagerProtocol {
    
    private let responseType: ResponseType?
        
    init(responseType: ResponseType) {
        self.responseType = responseType
    }
    
    func fetchAPIWeatherKey(completion: @escaping (Result<String, ForestCast.NetworkError>) -> Void) {
        switch responseType {
        case .success:
            return completion(.success("APIKeyMock"))
        case .failure:
            return completion(.failure(NetworkError.connectionError))
        case .none:
            return completion(.failure(NetworkError.noData))
        }
    }
    
}
