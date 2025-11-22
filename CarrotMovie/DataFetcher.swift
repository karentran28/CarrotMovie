//
//  DataFetcher.swift
//  CarrotMovie
//
//  Created by Karen Tran on 2025-11-21.
//

import Foundation

let tmdbBaseURL = APIConfig.shared?.tmdbBaseURL
let tmdbAPIKey = APIConfig.shared?.tmdbAPIKey

// async throws: does not run on main thread
func fetchTitles(for media: String) async throws -> [Title] {
    guard let baseURL = tmdbBaseURL else {
        throw NetworkError.missingConfig
    }
    
    guard let apiKey = tmdbAPIKey else {
        throw NetworkError.missingConfig
    }
    
    //https://api.themoviedb.org/3/trending/movie/day?api_key=YOUR_API_KEY
    guard let fetchTitlesURL = URL(string: baseURL)?
        .appending(path: "3/trending/\(media)/day")
        .appending(queryItems: [
            URLQueryItem(name: "api_key", value: apiKey)
        ]) else {
        throw NetworkError.urlBuildFailed
    }
    
    print(fetchTitlesURL)
    
    // data - raw json data from api
    let(data, urlResponse) = try await URLSession.shared.data(from: fetchTitlesURL)
    
    guard let response = urlResponse as? HTTPURLResponse, response.statusCode == 200 else {
        throw NetworkError.badURLResponse(underlyingError: NSError(
            domain: "DataFetcher",
            code: (urlResponse as? HTTPURLResponse)?.statusCode ?? -1,
            userInfo: [NSLocalizedDescriptionKey : "Invalid HTTP Response"]))
    }
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return try decoder.decode(APIObject.self, from: data).results
}
