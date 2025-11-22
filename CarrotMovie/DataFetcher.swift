//
//  DataFetcher.swift
//  CarrotMovie
//
//  Created by Karen Tran on 2025-11-21.
//

import Foundation

struct DataFetcher {
    let tmdbBaseURL = APIConfig.shared?.tmdbBaseURL
    let tmdbAPIKey = APIConfig.shared?.tmdbAPIKey
    
    let youtubeSearchURL = APIConfig.shared?.youtubeSearchURL
    let youtubeAPIKey = APIConfig.shared?.youtubeAPIKey

    // async throws: does not run on main thread
    func fetchTitles(for media: String, by type: String) async throws -> [Title] {
        let fetchTitlesURL = try buildURL(media: media, type: type)
        
        guard let fetchTitlesURL = fetchTitlesURL else {
            throw NetworkError.urlBuildFailed
        }
        
        print(fetchTitlesURL)
        var titles = try await fetchAndDecode(url: fetchTitlesURL, type: TMDBAPIObject.self).results
        
        Constants.addPosterPath(to: &titles)
        return titles
    }
    
    func fetchVideoId(for title: String) async throws -> String {
        guard let baseSearchURL = youtubeSearchURL else {
            throw NetworkError.missingConfig
        }
        
        guard let searchAPIKey = youtubeAPIKey else {
            throw NetworkError.missingConfig
        }
        
        let trailerSearch = title + YoutubeURLStrings.space.rawValue + YoutubeURLStrings.trailer.rawValue
        
        guard let fetchVideoURL = URL(string: baseSearchURL)?.appending(queryItems: [
            URLQueryItem(name: YoutubeURLStrings.queryShorten.rawValue, value: trailerSearch),
            URLQueryItem(name: YoutubeURLStrings.key.rawValue, value: searchAPIKey)
        ]) else {
            throw NetworkError.urlBuildFailed
        }
        print(fetchVideoURL)
        return try await fetchAndDecode(url: fetchVideoURL, type: YoutubeSearchResponse.self).items?.first?.id?.videoId ?? ""
    }
    
    func fetchAndDecode<T: Decodable>(url: URL, type: T.Type) async throws -> T {
        // data - raw json data from api
        let(data, urlResponse) = try await URLSession.shared.data(from: url)
        
        // unwrap and check HTTP response
        guard let response = urlResponse as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badURLResponse(underlyingError: NSError(
                domain: "DataFetcher",
                code: (urlResponse as? HTTPURLResponse)?.statusCode ?? -1,
                userInfo: [NSLocalizedDescriptionKey : "Invalid HTTP Response"]))
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(type, from: data)
    }
    
    private func buildURL(media: String, type: String) throws -> URL? {
        guard let baseURL = tmdbBaseURL else {
            throw NetworkError.missingConfig
        }
        
        guard let apiKey = tmdbAPIKey else {
            throw NetworkError.missingConfig
        }
        
        var path: String
        
        if type == "trending" {
            path = "3/\(type)/\(media)/day"
        } else if type == "top_rated" || type == "upcoming" {
            path = "3/\(media)/\(type)"
        } else {
            throw NetworkError.urlBuildFailed
        }
        
        //https://api.themoviedb.org/3/trending/movie/day?api_key=YOUR_API_KEY
        //https://api.themoviedb.org/3/movie/top_rated?api_key=YOUR_API_KEY
        //https://api.themoviedb.org/3/movie/upcoming?api_key=YOUR_API_KEY
        guard let url = URL(string: baseURL)?
            .appending(path: path)
            .appending(queryItems: [
                URLQueryItem(name: "api_key", value: apiKey)
            ]) else {
            throw NetworkError.urlBuildFailed
        }
        
        return url
    }
}
