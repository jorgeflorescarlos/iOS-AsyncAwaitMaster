//
//  NewsSource.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import Foundation

struct NewsSourceResponse: Decodable {
    let sources: [NewsSource]
}

struct NewsSource: Decodable {
    let id: String
    let name: String
    let description: String
}
