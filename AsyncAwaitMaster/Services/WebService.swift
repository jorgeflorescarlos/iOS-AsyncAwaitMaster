//
//  WebService.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case invalidData
    case decodingError
    case badRequest
}

enum FetchStrategy: CustomStringConvertible, CaseIterable, Identifiable {
    var description: String {
        switch self {
        case .async:
            "Async"
        case .continuation:
            "Continuation"
        }
    }
    
    var id: Self { self }
    
    case async, continuation
    
}

protocol GetNewsAsyncStrategyProtocol {
    func fetchSourcesAsync(url: URL?) async throws -> [NewsSource]
    func fetchNewsAsync(url: URL?) async throws -> [NewsArticle]
}

protocol GetNewsContinuationStrategyProtocol {
    func fetchSourcesAsyncContinuation(url: URL?) async throws -> [NewsSource]
    func fetchNewsAsyncContinuation(url: URL?) async throws -> [NewsArticle]
}

protocol GetNewsProtocol {
    func fetchSourcesAsyncContinuation(url: URL?) async throws -> [NewsSource]
    func fetchNewsAsyncContinuation(url: URL?) async throws -> [NewsArticle]
}

protocol GetRandomQuotesAndImagesProtocol {
    func getRandomImages(ids: [Int]) async throws -> [RandomImage]
    func getRandomImage(id: Int) async throws -> RandomImage
}

protocol GetTodosProtocol {
    func getAllTodosAsync(url: URL) async throws -> [Todo]
    func getAllTodos(url: URL, completion: @escaping (Result<[Todo], NetworkError>) -> Void)
}

class WebService: GetNewsAsyncStrategyProtocol {
    
    func getDate() async throws -> CurrentDate? {
        guard let url = URL(string: "https://ember-sparkly-rule.glitch.me/current-date") else {
            throw NetworkError.badUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try? JSONDecoder().decode(CurrentDate.self, from: data)
    }
    
    func fetchSourcesAsync(url: URL?) async throws -> [NewsSource] {
        
        guard let url = url else {
            return []
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let newsSourceResponse = try? JSONDecoder().decode(NewsSourceResponse.self, from: data)
        
        return newsSourceResponse?.sources ?? []
        
    }
    
    func fetchNewsAsync(url: URL?) async throws -> [NewsArticle] {
        
        guard let url = url else {
            return []
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let newsArticleResponse = try? JSONDecoder().decode(NewsArticleResponse.self, from: data)
        
        return newsArticleResponse?.articles ?? []
        
    }
    
    
}

extension WebService: GetNewsContinuationStrategyProtocol {
    func fetchSourcesAsyncContinuation(url: URL?) async throws -> [NewsSource] {
        try await withCheckedThrowingContinuation { continuation in
            fetchSources(url: url) { result in
                switch result {
                case .success(let newsSources):
                    continuation.resume(returning: newsSources)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetchNewsAsyncContinuation(url: URL?) async throws -> [NewsArticle] {
        try await withCheckedThrowingContinuation { continuation in
            fetchNews(url: url) { result in
                switch result {
                case .success(let newsArticles):
                    continuation.resume(returning: newsArticles)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

extension WebService: GetNewsProtocol {
    private func fetchSources(url: URL?, completion: @escaping (Result<[NewsSource], NetworkError>) -> Void) {
        
        guard let url = url else {
            completion(.failure(.badUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            
            let newsSourceResponse = try? JSONDecoder().decode(NewsSourceResponse.self, from: data)
            completion(.success(newsSourceResponse?.sources ?? []))
        }.resume()
    }
    
    private func fetchNews(url: URL?, completion: @escaping (Result<[NewsArticle], NetworkError>) -> Void) {
        
        guard let url = url else {
            completion(.failure(.badUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            
            let newsArticleResponse = try? JSONDecoder().decode(NewsArticleResponse.self, from: data)
            completion(.success(newsArticleResponse?.articles ?? []))
            
        }.resume()
        
    }
}

extension WebService: GetRandomQuotesAndImagesProtocol {
    func getRandomImages(ids: [Int]) async throws -> [RandomImage] {
        
        var randomImages: [RandomImage] = []
        
        for id in ids {
            let randomImage = try await getRandomImage(id: id)
            randomImages.append(randomImage)
        }
        
        try await withThrowingTaskGroup(of: (Int, RandomImage).self, body: { group in
            
            for id in ids {
                group.addTask {
                    return (id, try await self.getRandomImage(id: id))
                }
            }
            
            for try await (_, randomImage) in group {
                randomImages.append(randomImage)
            }
            
        })
        return randomImages
    }
    
    func getRandomImage(id: Int) async throws -> RandomImage {
        
        guard let url = Constants.Urls.getRandomImageUrl() else {
            throw NetworkError.badUrl
        }
        
        guard let randomQuoteUrl = Constants.Urls.randomQuoteUrl else {
            throw NetworkError.badUrl
        }
        
        async let (imageData, _) = try URLSession.shared.data(from: url)
        async let (randomQuoteData, _) = URLSession.shared.data(from: randomQuoteUrl)
        
        guard let quote = try? JSONDecoder().decode(Quote.self, from: try await randomQuoteData) else {
            throw NetworkError.decodingError
        }
        
        return RandomImage(image: try await imageData, quote: quote)
    }
}

extension WebService: GetTodosProtocol {
    func getAllTodosAsync(url: URL) async throws -> [Todo] {
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let todos = try? JSONDecoder().decode([Todo].self, from: data)
        return todos ?? []
    }
    
    func getAllTodos(url: URL, completion: @escaping (Result<[Todo], NetworkError>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.badRequest))
                return
            }
            
            guard let todos = try? JSONDecoder().decode([Todo].self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            completion(.success(todos))
        }.resume()
    }
}
