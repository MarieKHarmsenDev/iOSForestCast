//
//  HomeNetworkManager.swift
//  ForestCast
//
//  Created by Marie Harmsen on 03/04/2025.
//

import FirebaseDatabase

protocol HomeNetworkManagerProtocol {
    func fetchAPIWeatherKey(completion: @escaping(Result<String, NetworkError>) -> Void)
    func fetchGooglePlacesKey(completion: @escaping(Result<String, NetworkError>) -> Void)
}

class HomeNetworkManager: HomeNetworkManagerProtocol {
    
    func fetchAPIWeatherKey(completion: @escaping(Result<String, NetworkError>) -> Void) {
        let reference = Database.database().reference()
        reference.child("APIWeatherKey").getData { error, snapshot in
            if let apiKey = snapshot?.value as? String {
                completion(.success(apiKey))
            } else {
                completion(.failure(.decodeDataProblem))
            }
        }
    }
    
    func fetchGooglePlacesKey(completion: @escaping(Result<String, NetworkError>) -> Void) {
        let reference = Database.database().reference()
        reference.child("GoogleAPIKey").getData { error, snapshot in
            if let apiKey = snapshot?.value as? String {
                completion(.success(apiKey))
            } else {
                completion(.failure(.decodeDataProblem))
            }
        }
    }
}
