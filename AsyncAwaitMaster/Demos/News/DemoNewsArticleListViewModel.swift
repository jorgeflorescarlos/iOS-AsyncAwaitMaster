//
//  DemoNewsArticleListViewModel.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import Foundation

@MainActor
class NewsArticleListViewModel: ObservableObject {
    
    @Published var newsArticles = [NewsArticleViewModel]()
    @Published var strategy: FetchStrategy = .async
    @Published var errorMessage = ""
    @Published var store = Constants.Urls.shared
    
    func getNewsBy(sourceId: String) async {
        do {
            switch strategy {
            case .async:
                let newsArticles = try await WebService().fetchNewsAsync(url: store.topHeadlines(by: sourceId))
                    self.newsArticles = newsArticles.map(NewsArticleViewModel.init)
            case .continuation:
                let newsArticles = try await WebService().fetchNewsAsyncContinuation(url: store.topHeadlines(by: sourceId))
                    self.newsArticles = newsArticles.map(NewsArticleViewModel.init)
            }
            errorMessage = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct NewsArticleViewModel: Identifiable {
    
    let id = UUID()
    fileprivate let newsArticle: NewsArticle
    
    var title: String {
        newsArticle.title
    }
    
    var description: String {
        newsArticle.description ?? ""
    }
    
    var author: String {
        newsArticle.author ?? ""
    }
    
    var urlToImage: URL? {
        URL(string: newsArticle.urlToImage ?? "")
    }
    
}
