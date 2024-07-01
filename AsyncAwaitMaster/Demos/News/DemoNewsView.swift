//
//  DemoNewsView.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import SwiftUI

struct DemoNewsView: View {
    
    let newsSource: NewsSourceViewModel
    @StateObject private var newsArticleListViewModel = NewsArticleListViewModel()
    
    var body: some View {
        List {
            Text("Async Strategy:")
            Picker("Strategy", selection: $newsArticleListViewModel.strategy) {
                ForEach(FetchStrategy.allCases) { option in
                    Text(String(describing: option))
                }
            }
            .pickerStyle(.segmented)
            ForEach(newsArticleListViewModel.newsArticles) {newsArticle in
                NewsArticleCell(newsArticle: newsArticle)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await newsArticleListViewModel.getNewsBy(sourceId: newsSource.id) }
                } label: {
                    Image(systemName: "arrow.clockwise.circle")
                }
            }
        }
        .listStyle(.plain)
        .task {
            await newsArticleListViewModel.getNewsBy(sourceId: newsSource.id)
        }
        .navigationTitle(newsSource.name)
    }
}

struct NewsArticleCell: View {
    
    let newsArticle: NewsArticleViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: newsArticle.urlToImage) { image in
                image.resizable()
                    .frame(maxWidth: 100, maxHeight: 100)
            } placeholder: {
                ProgressView("Loading...")
                    .frame(maxWidth: 100, maxHeight: 100)
            }
            
            VStack {
                Text(newsArticle.title)
                    .lineLimit(4)
                    .fontWeight(.bold)
                Text(newsArticle.description)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DemoNewsView(newsSource: NewsSourceViewModel.default)
    }
}
