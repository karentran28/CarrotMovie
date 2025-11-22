//
//  DownloadView.swift
//  CarrotMovie
//
//  Created by Karen Tran on 2025-11-22.
//

import SwiftUI
import SwiftData

struct DownloadView: View {
    @Query(sort: \Title.title) var savedTitles: [Title]
    
    var body: some View {
        NavigationStack {
            if savedTitles.isEmpty {
                Text("No downloads")
                    .padding()
                    .font(.title3)
                    .bold()
            } else {
                VStack {
                    Text("Downloads")
                    VerticalListView(titles: savedTitles, canDelete: true)
                }
                
            }
        }
    }
}

#Preview {
    DownloadView()
}
