//
//  KeyManager.swift
//  ForestCast
//
//  Created by Marie Harmsen on 07/04/2025.
//

class KeyManager {
    static var shared = KeyManager()
    
    private init() {}
    
    var apiKey: String = ""
        
    func setApiKey(key: String) {
        apiKey = key
    }
}
