//
//  HomeView.swift
//  CarrotMovie
//
//  Created by Karen Tran on 2025-11-20.
//

import SwiftUI

struct HomeView: View {
    var heroTestTitle = Constants.testTitleURL
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                LazyVStack {
                    //Image needs to be fetched async since coming from online
                    //AsyncImage takes a URL so we change our string to type URL
                    AsyncImage(url: URL(string: heroTestTitle)){ image in
                        image
                            .resizable()
                            .scaledToFit()
                            .overlay {
                                LinearGradient(
                                    stops: [Gradient.Stop(color: .clear, location: 0.8),
                                            Gradient.Stop(color: .gradient, location: 1)],
                                    startPoint: .top,
                                    endPoint: .bottom)
                            }
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: geo.size.width, height: geo.size.height * 0.85)
                    
                    HStack {
                        Button {
                            
                        } label: {
                            Text(Constants.playString)
                                .ghostButton()
                        }
                        
                        Button {
                            
                        } label: {
                            Text(Constants.downloadString)
                                .ghostButton()
                        }
                    }
                    
                    HorizontalListView(header: Constants.trendingMoviesString)
                    HorizontalListView(header: Constants.trendingTVString)
                    HorizontalListView(header: Constants.topRatedMoviesString)
                    HorizontalListView(header: Constants.topRatedTVString)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
