//
//  Errors.swift
//  CarrotMovie
//
//  Created by Karen Tran on 2025-11-21.
//

import Foundation

enum APIConfigError: Error, LocalizedError {
    case fileNotFound
    // these errors can occur from more than one underlying error
    case dataLoadingFailed(underlyingError: Error)
    case decodingFailed(underlyingError: Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "API config file not found"
        case .dataLoadingFailed(underlyingError: let error):
            return "Failed to load data from API config file: \(error.localizedDescription)"
        case .decodingFailed(underlyingError: let error):
            return "Failed to decode API config: \(error.localizedDescription)"
        }
    }
}
