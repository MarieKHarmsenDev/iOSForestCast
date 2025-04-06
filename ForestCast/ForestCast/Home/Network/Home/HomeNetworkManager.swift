//
//  HomeNetworkManager.swift
//  ForestCast
//
//  Created by Marie Harmsen on 03/04/2025.
//

import FirebaseDatabase

class HomeNetworkManager {

    func fetchAPIWeatherKey(completion: @escaping(Result<String, NetworkError>) -> Void) {
        let reference = Database.database().reference()
        reference.child("APIWeatherKey").observeSingleEvent(of: .value, with: { snapshot in
            if let apiKey = snapshot.value as? String {
                completion(.success(apiKey))
            } else {
                completion(.failure(.decodeDataProblem))
            }
        }) { error in
            completion(.failure(.connectionError))
        }
    }
}
