//
//  DemoDatesView.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import SwiftUI

struct CurrentDate: Codable {
    let date: String
}

struct CurrentDateModel: Identifiable {
    let id = UUID()
    let date: CurrentDate
}

struct DemoDatesView: View {
    
    @State private var currentDates: [CurrentDateModel] = []
    @State private var errorMessages = "none"
    
    var body: some View {
        VStack {
            Section {
                List(currentDates) { currentDate in
                    Text(currentDate.date.date)
                }
                .listStyle(.grouped)
            } header: {
                Text("Display dates using async/await approach")
            } footer: {
                Text("Errors:")
                    .font(.title2)
                Text(errorMessages)
            }
        }
        .navigationTitle("Dates")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await populateDates() }
                } label: {
                    Image(systemName: "arrow.clockwise.circle")
                }
            }
        }
        .task {
            await populateDates()
        }
    }
    
    private func getDate() async throws -> CurrentDate? {
        guard let url = URL(string: "https://ember-sparkly-rule.glitch.me/current-date") else {
            fatalError("Url Invalid")
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try? JSONDecoder().decode(CurrentDate.self, from: data)
    }
    
    private func populateDates() async {
        do {
            guard let currentDate = try await getDate() else { return }
            
            self.currentDates.append(CurrentDateModel(date: currentDate))
            self.errorMessages = "none"
        } catch {
            errorMessages = error.localizedDescription
        }
    }
}

#Preview {
    NavigationStack {
        DemoDatesView()
    }
}
