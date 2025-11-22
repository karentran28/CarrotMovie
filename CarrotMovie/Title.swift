//
//  Title.swift
//  CarrotMovie
//
//  Created by Karen Tran on 2025-11-21.
//

import Foundation

// array that holds objects of type Title
// default value of an empty array
struct APIObject: Decodable {
    var results: [Title] = []
}

// conforms to decodable and identifiable protocols
// decodable allows title to be created from an external data source
// identifiable requires title to have a unique ID property that uniquely identifies each instance
struct Title: Decodable, Identifiable {
    var id: Int?
    var title: String?
    var name: String?
    var overview: String?
    var posterPath: String?
    
    static var previewTitles = [
        Title(id: 1, title: "BeetleJuice", name: "BeetleJuice", overview: "A movie about BeetleJuice", posterPath: Constants.testTitleURL),
        Title(id: 2, title: "Pulp Fiction", name: "Pulp Fiction", overview: "A movie about Pulp Fiction", posterPath: Constants.testTitleURL2),
        Title(id: 3, title: "The Dark Knight", name: "The Dark Knight", overview: "A movie about The Dark Knight", posterPath: Constants.testTitleURL3)
    ]
}
