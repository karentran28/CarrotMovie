//
//  YoutubeSearchResponse.swift
//  CarrotMovie
//
//  Created by Karen Tran on 2025-11-21.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [itemProperties]?
}

struct itemProperties: Codable {
    let id: IdProperties?
}

struct IdProperties: Codable {
    let videoId: String?
}
