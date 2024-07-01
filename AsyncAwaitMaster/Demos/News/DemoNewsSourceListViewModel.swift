//
//  DemoNewsSourceListViewModel.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import Foundation

@MainActor
class NewsSourceListViewModel: ObservableObject {
    
    @Published var newsSources: [NewsSourceViewModel] = []
    @Published var strategy: FetchStrategy = .async
    @Published var apiKey = ""
    @Published var errorMessage = ""
    @Published var store = Constants.Urls.shared
    
    func getSources() async {
        store.apiKey = apiKey
        newsSources = []
        do {
            switch strategy {
            case .async:
                let newsSources = try await WebService().fetchSourcesAsync(url: store.sources())
                self.newsSources = newsSources.map(NewsSourceViewModel.init)
            case .continuation:
                let newsSources = try await WebService().fetchSourcesAsyncContinuation(url: store.sources())
                self.newsSources = newsSources.map(NewsSourceViewModel.init)
            }
            errorMessage = ""
        } catch {
            errorMessage = error.localizedDescription
            print(error)
        }
    }
}

struct NewsSourceViewModel: Identifiable {
    
    fileprivate var newsSource: NewsSource
    
    var id: String {
        newsSource.id
    }
    
    var name: String {
        newsSource.name
    }
    
    var description: String {
        newsSource.description
    }
    
    static var `default`: NewsSourceViewModel {
        let newsSource = NewsSource(id: "abc-news", name: "ABC News", description: "This is ABC news")
        return NewsSourceViewModel(newsSource: newsSource)
    }
}
