//
//  LessonDetails.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import Foundation
import SwiftUI

struct LessonDetailsView: View {
    @State var lesson: Lesson
    
    var body: some View {
        switch lesson {
        case .datesDemo:
            DemoDatesView()
        case .continuation:
            Text(lesson.name)
        case .newsDemo:
            Text(lesson.name)
        case .structuredConcurrency:
            Text(lesson.name)
        case .randomImagesDemo:
            Text(lesson.name)
        case .asyncSequence:
            Text(lesson.name)
        case .concurrentProgramming:
            Text(lesson.name)
        case .actors:
            Text(lesson.name)
        }
    }
}

#Preview {
    LessonDetailsView(lesson: .datesDemo)
}
