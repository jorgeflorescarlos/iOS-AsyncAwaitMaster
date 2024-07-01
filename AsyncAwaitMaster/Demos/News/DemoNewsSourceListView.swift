//
//  DemoNewsSourceListView.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import SwiftUI

struct DemoNewsSourceListView: View {
    @StateObject private var newsSourceListViewModel = NewsSourceListViewModel()
    
    var body: some View {
        
        List {
            Section("Definition") {
                Text("Continuations allow us to create a shim between the completion handler and async functions so that we wrap up the older code in a more modern API.")
                
            }
            Section("Configuration"){
                LabeledContent("Api Key") {
                    TextField("Api Key", text: $newsSourceListViewModel.apiKey)
                }
                Text("Async Strategy:")
                Picker("Strategy", selection: $newsSourceListViewModel.strategy) {
                    ForEach(FetchStrategy.allCases) { option in
                        Text(String(describing: option))
                    }
                }.pickerStyle(.segmented)
            }
            Section("News") {
                ForEach(newsSourceListViewModel.newsSources) { newsSource in
                    NavigationLink(destination: DemoNewsView(newsSource: newsSource)) {
                        NewsSourceCell(newsSource: newsSource)
                    }
                }
            }
        }
        .task({
            await newsSourceListViewModel.getSources()
        })
        .navigationTitle("News Sources")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await newsSourceListViewModel.getSources() }
                } label: {
                    Image(systemName: "arrow.clockwise.circle")
                }
                .disabled(newsSourceListViewModel.apiKey.isEmpty)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DemoNewsSourceListView()
    }
}

struct NewsSourceCell: View {
    
    let newsSource: NewsSourceViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(newsSource.name)
                .font(.headline)
            Text(newsSource.description)
        }
    }
}
