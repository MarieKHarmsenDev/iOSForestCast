//
//  NetworkErrors.swift
//  ForestCast
//
//  Created by Marie Harmsen on 06/04/2025.
//

enum NetworkError: Error {
    case connectionError
    case decodeDataProblem
    case noData
    case malformedURL
}
