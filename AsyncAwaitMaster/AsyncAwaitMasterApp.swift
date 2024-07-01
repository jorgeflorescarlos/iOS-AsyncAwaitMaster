//
//  AsyncAwaitMasterApp.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import SwiftUI
import SwiftData
import WhatsNewKit

@main
struct AsyncAwaitMasterApp: App {
    
    var whatsNewCollection: WhatsNewCollection {
        [
            WhatsNew(
                version: "1.0.0",
                title: "Welcome to AsyncAwaitDemo",
                features: [
                    WhatsNew.Feature(image: WhatsNew.Feature.Image(systemName: "clock"), title: "View async/await demos", subtitle: "Browse into sections with explanations"),
                    WhatsNew.Feature(image: WhatsNew.Feature.Image(systemName: "medal"), title: "Get inspiration", subtitle: "Try this implementations in your own apps")
                ]
            )
        ]
    }
    
    var body: some Scene {
        WindowGroup {
            LessonView()
                .environment(
                    \.whatsNew,
                     WhatsNewEnvironment(
                        versionStore: UserDefaultsWhatsNewVersionStore(),
                        whatsNewCollection: self.whatsNewCollection
                     )
                )
        }
    }
}
