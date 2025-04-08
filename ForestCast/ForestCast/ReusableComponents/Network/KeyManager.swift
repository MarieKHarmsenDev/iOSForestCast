//
//  KeyManager.swift
//  ForestCast
//
//  Created by Marie Harmsen on 07/04/2025.
//

class KeyManager {
    static var shared = KeyManager()
    
    private init() {}
    
    private var apiKey: String = ""
    private var googleApiKey: String = ""
        
    func setApiKey(key: String) {
        apiKey = key
    }
    
    func setGoogleApiKey(key: String) {
        googleApiKey = key
    }
    
    func getGoogleAPIKey() -> String {
        // Should have some obfuscation/hashing here
        removeSalt(key: googleApiKey, letter: "B")
    }
    
    func getAPIKey() -> String {
        // Should have some obfuscation/hashing here
        removeSalt(key: apiKey, letter: "Z")
    }
    
    private func removeSalt(key: String, letter: String) -> String {
        key.replacingOccurrences(of: letter, with: "")
    }
}
