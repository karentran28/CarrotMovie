//
//  APIConfig.swift
//  CarrotMovie
//
//  Created by Karen Tran on 2025-11-21.
//

//used for reading and accessing contents of the json file
// allows us to dynamically load sensitive information (api key)
// into app at runtime
import Foundation

struct APIConfig: Decodable {
    let tmdbBaseURL: String
    let tmdbAPIKey: String
    
    //lazy singleton
    static let shared: APIConfig? = {
        do {
            return try loadConfig()
        } catch {
            print("Failed to load API config: \(error.localizedDescription)")
            //if fails shared = nil
            return nil
        }
    }()
    
    
    private static func loadConfig() throws -> APIConfig {
        guard let url = Bundle.main.url(forResource: "APIConfig", withExtension: "json") else {
            throw APIConfigError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(APIConfig.self, from: data)
        } catch let error as DecodingError {
            throw APIConfigError.decodingFailed(underlyingError: error)
        } catch {
            throw APIConfigError.dataLoadingFailed(underlyingError: error)
        }
    }
}
