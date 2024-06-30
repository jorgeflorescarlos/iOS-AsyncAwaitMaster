//
//  LessonView.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import SwiftUI
import SwiftData
import WhatsNewKit

struct LessonView: View {
    @StateObject private var model = LessonViewModel()
    @State private var presentedLessons: [Lesson] = []
    
    
    var body: some View {
        NavigationStack(path: $presentedLessons) {
            List(model.lessons) { lesson in
                NavigationLink(value: lesson) {
                    HStack {
                        Image(systemName: lesson.icon)
                        Text(lesson.name)
                    }
                }
            }
            .navigationTitle("Async/Await Demos")
            .navigationDestination(for: Lesson.self) { lesson in
                LessonDetailsView(lesson: lesson)
            }
        }
        
        .task {
            await model.loadLessons()
        }
        .whatsNewSheet()
    }
}

#Preview {
    LessonView()
}
