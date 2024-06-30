//
//  LessonViewModel.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import Foundation

@MainActor
class LessonViewModel: ObservableObject {
    @Published var lessons: [Lesson] = []
    
    private let lessonStore = LessonStore()
    
    func loadLessons() async {
        lessons = await lessonStore.lessons
    }
}
