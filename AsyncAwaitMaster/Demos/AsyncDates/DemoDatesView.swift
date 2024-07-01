//
//  DemoDatesView.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import SwiftUI

struct DemoDatesView: View {
    
    @StateObject private var currentDateVM = CurrentDateViewModel()
    
    var body: some View {
        List {
            Section {
                if currentDateVM.currentDates.isEmpty {
                    ProgressView()
                }
                ForEach(currentDateVM.currentDates) { currentDate in
                    Text(currentDate.date)
                }
            } header: {
                Text("Display dates using async/await approach")
            } footer: {
                HStack {
                    Text("Errors:")
                        .bold()
                    Text(currentDateVM.errorMessages)
                }
                
            }
        }
        .navigationTitle("Dates")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await currentDateVM.populateDates() }
                } label: {
                    Image(systemName: "arrow.clockwise.circle")
                }
            }
        }
        .task {
            await currentDateVM.populateDates()
        }
    }
}

#Preview {
    NavigationStack {
        DemoDatesView()
    }
}
