//
//  Route.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import Foundation

enum Lesson: Identifiable, Hashable, CaseIterable {
    case datesDemo, continuation, newsDemo, structuredConcurrency, randomImagesDemo, asyncSequence, concurrentProgramming, actors
    
    var id: UUID {
        return UUID()
    }
    
    var name: String {
        switch self {
        case .datesDemo:
            return "Handling Dates Demo"
        case .continuation:
            return "Continuation"
        case .newsDemo:
            return "News Demo"
        case .structuredConcurrency:
            return "Structured Concurrency Demo"
        case .randomImagesDemo:
            return "Renadom Images Demo"
        case .asyncSequence:
            return "Async sequence Demo"
        case .concurrentProgramming:
            return "concurrent Programing Demo"
        case .actors:
            return "Actors Demo"
        }
    }
    
    var icon: String {
        switch self {
        case .datesDemo:
            return "calendar"
        case .continuation:
            return "arrowshape.bounce.forward"
        case .newsDemo:
            return "newspaper"
        case .structuredConcurrency:
            return "arrow.triangle.turn.up.right.circle"
        case .randomImagesDemo:
            return "arrow.triangle.turn.up.right.circle"
        case .asyncSequence:
            return "arrow.triangle.turn.up.right.circle"
        case .concurrentProgramming:
            return "arrow.triangle.turn.up.right.circle"
        case .actors:
            return "arrow.triangle.turn.up.right.circle"
        }
    }
    
    static var lessons: [Lesson] {
        return self.allCases
    }
}
