//
//  HomeView.swift
//  CarrotMovie
//
//  Created by Karen Tran on 2025-11-20.
//

import SwiftUI

struct HomeView: View {
    let viewModel = ViewModel()
    @State private var titleDetailPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $titleDetailPath) {
            GeometryReader { geo in
                ScrollView(.vertical) {
                    switch viewModel.homeStatus {
                    case .notStarted:
                        EmptyView()
                    case .fetching:
                        ProgressView()
                            .frame(width: geo.size.width, height: geo.size.height)
                    case .success:
                        LazyVStack {
                            //Image needs to be fetched async since coming from online
                            //AsyncImage takes a URL so we change our string to type URL
                            AsyncImage(url: URL(string: viewModel.heroTitle.posterPath ?? "")){ image in
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
                                    // append Title object to path
                                    titleDetailPath.append(viewModel.heroTitle)
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
                            
                            HorizontalListView(header: Constants.trendingMoviesString, titles: viewModel.trendingMovies)
                            HorizontalListView(header: Constants.trendingTVString, titles: viewModel.trendingTV)
                            HorizontalListView(header: Constants.topRatedMoviesString, titles: viewModel.topRatedMovies)
                            HorizontalListView(header: Constants.topRatedTVString, titles: viewModel.topRatedTV)
                        }
                        // when a Title object gets added to path, show that title's detail view
                        .navigationDestination(for: Title.self) { title in
                            TitleDetailView(title: title)
                        }
                    case .failed(let underlyingError):
                        Text("Error: \(underlyingError.localizedDescription)")
                    }
                }
                .task {
                    await viewModel.getTitles()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
