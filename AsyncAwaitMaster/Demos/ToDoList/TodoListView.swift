//
//  TodoListView.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import SwiftUI

struct TodoListView: View {
    @StateObject private var todoListVM = TodoListViewModel()
    
    var body: some View {
        List {
            Section("Goal") {
                Text("Download a list of items using Detached Tasks")
            }
            Section("Definition") {
                Text("Detached tasks allow you to create a new top-level task and disconnect from the current structured concurrency context.")
            }
            Section("Example") {
                ForEach(todoListVM.todos, id: \.id) { todo in
                    Text(todo.title)
                }
            }
        }
        .navigationTitle("Todos")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await todoListVM.populateTodos() }
                } label: {
                    Image(systemName: "arrow.clockwise.circle")
                }
            }
        }
        .task {
            await todoListVM.populateTodos()
        }
    }
}

#Preview {
    NavigationStack {
        TodoListView()
    }
}
