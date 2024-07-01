//
//  DemoDatesViewModel.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import Foundation

struct CurrentDateModel: Identifiable {
    let currentDate: CurrentDate
    let id = UUID()
    var date: String {
        currentDate.date
    }
}

@MainActor
class CurrentDateViewModel: ObservableObject {
    
    @Published var currentDates: [CurrentDateModel] = []
    @Published var errorMessages = "none"
    
    func populateDates() async {
        do {
            let currentDate = try await WebService().getDate()
            if let currentDate = currentDate {
                let currentDateViewModel = CurrentDateModel(currentDate: currentDate)
                self.currentDates.append(currentDateViewModel)
                errorMessages = "none"
            }
        } catch {
            print(error)
            errorMessages = error.localizedDescription
        }
    }
}
