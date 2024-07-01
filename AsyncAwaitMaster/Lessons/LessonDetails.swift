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
        case .newsDemo:
            DemoNewsSourceListView()
        case .randomImagesDemo:
            RandomQuotesAndImagesView()
        case .concurrentProgramming:
            TodoListView()
        case .actors:
            BankAccountView()
        }
    }
}

#Preview {
    LessonDetailsView(lesson: .datesDemo)
}
