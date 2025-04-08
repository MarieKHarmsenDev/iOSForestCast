//
//  NearbyNetworkManager.swift
//  ForestCast
//
//  Created by Marie Harmsen on 08/04/2025.
//

import Foundation

protocol NearbyNetworkManagerProtocol {
    func fetchNearbyPlaces(completion: @escaping(Result<[Place], NetworkError>) -> Void)
}

class NearbyNetworkManager: NearbyNetworkManagerProtocol {
    
    private let networkLogger = NetworkLogger()
    
    func fetchNearbyPlaces(completion: @escaping(Result<[Place], NetworkError>) -> Void) {
        
        let key = KeyManager.shared.getGoogleAPIKey()
        
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(LocationValuesManager.shared.latitude),\(LocationValuesManager.shared.longitude)&radius=1000&key=\(key)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data {
                guard let nearbyPlaces = self?.decodeJSON(data: data) else { return }
                completion(.success(nearbyPlaces))
            }
        }
        task.resume()
    }
    
    private func decodeJSON(data: Data) -> [Place]? {
        do {
            let json = try JSONDecoder().decode(NearbyPlacesModel.self, from: data)
            return json.results
        } catch {
            networkLogger.logError("Failed to decode nearby places")
        }
        return nil
    }
}
