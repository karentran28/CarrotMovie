//
//  CarrotMovieApp.swift
//  CarrotMovie
//
//  Created by Karen Tran on 2025-11-20.
//

import SwiftUI
import SwiftData

@main
struct CarrotMovieApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Title.self)
    }
}
