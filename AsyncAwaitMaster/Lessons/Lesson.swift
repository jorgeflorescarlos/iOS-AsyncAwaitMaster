//
//  Route.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import Foundation

enum Lesson: Identifiable, Hashable, CaseIterable {
    case datesDemo, newsDemo, randomImagesDemo, concurrentProgramming, actors
    
    var id: UUID {
        return UUID()
    }
    
    var name: String {
        switch self {
        case .datesDemo:
            return "Handling Dates Demo"
        case .newsDemo:
            return "News Demo"
        case .randomImagesDemo:
            return "Random Images with Quotes Demo"
        case .concurrentProgramming:
            return "Concurrent ToDo List"
        case .actors:
            return "Bank Account Demo"
        }
    }
    
    var icon: String {
        switch self {
        case .datesDemo:
            return "calendar"
        case .newsDemo:
            return "newspaper"
        case .randomImagesDemo:
            return "text.below.photo"
        case .concurrentProgramming:
            return "checklist.unchecked"
        case .actors:
            return "banknote"
        }
    }
    
    static var lessons: [Lesson] {
        return self.allCases
    }
}
