//
//  TodoListViewModel.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import Foundation

@MainActor
class TodoListViewModel: ObservableObject {
    
    @Published var todos: [TodoViewModel] = []
    
    func populateTodos() async {
        do {
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {
                throw NetworkError.badUrl
            }
            todos = []
            Task.detached {
                let todos = try await WebService().getAllTodosAsync(url: url)
                await MainActor.run {
                    self.todos = todos.map(TodoViewModel.init)
                }
            }
        } catch {
            print(error)
        }
    }
}

struct TodoViewModel {
    
    let todo: Todo
    
    var id: Int {
        todo.id
    }
    
    var title: String {
        todo.title
    }
    
    var completed: Bool {
        todo.completed
    }
}
