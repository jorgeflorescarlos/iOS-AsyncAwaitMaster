//
//  Constants.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import Foundation

struct Constants {
    class Urls {
        var apiKey = ""
        static var shared = Urls()
        
        func topHeadlines(by source: String) -> URL? {
            return URL(string: "https://newsapi.org/v2/top-headlines?sources=\(source)&apiKey=\(apiKey)")
        }
                
        func sources() -> URL? {
            return URL(string: "https://newsapi.org/v2/sources?apiKey=\(apiKey)")
        }
        
        static func getRandomImageUrl() -> URL? {
            return URL(string: "https://picsum.photos/200/300?uuid=\(UUID().uuidString)")
        }
        
        static let randomQuoteUrl: URL? = URL(string: "https://api.quotable.io/random")
    }
}
