//
//  RandomImage.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import Foundation

struct RandomImage: Decodable {
    let image: Data
    let quote: Quote
}

struct Quote: Decodable {
    let content: String
}
