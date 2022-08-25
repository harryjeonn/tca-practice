//
//  TodoView.swift
//  TCAPractice
//
//  Created by Harry on 2022/08/25.
//

import SwiftUI
import ComposableArchitecture

struct TodoState: Equatable {
    var todo: String = ""
    var todos: [String] = ["Defalut"]
    var isEditing: Bool = false
    var selectedTodo: Int = 0
    var editedTodo: String = ""
}

enum TodoAction: Equatable {
    case textFieldChanged(String)
    case addTodo
    case todoTapped(Int)
    case alertConfirmTapped
    case alertCancelTapped
    case editedTodo(String)
    case deleteTodo(IndexSet)
}

struct TodoEnvironment: Equatable {}

let todoReducer = Reducer<TodoState, TodoAction, TodoEnvironment> { state, action, _ in
    switch action {
    case let .textFieldChanged(todo):
        state.todo = todo
        return .none
        
    case .addTodo:
        if state.todo.description != "" {
            state.todos.insert(state.todo, at: 0)
            state.todo = ""
        }
        return .none
        
    case let .todoTapped(index):
        state.isEditing = true
        state.selectedTodo = index
        return .none
        
    case .alertConfirmTapped:
        state.todos[state.selectedTodo] = state.editedTodo
        state.isEditing = false
        return .none
        
    case .alertCancelTapped:
        state.isEditing = false
        return .none
        
    case let .editedTodo(editedTodo):
        state.editedTodo = editedTodo
        return .none
        
    case let .deleteTodo(indexSet):
        state.todos.remove(atOffsets: indexSet)
        return .none
    }
}

struct TodoView: View {
    let store = Store(initialState: TodoState(), reducer: todoReducer, environment: TodoEnvironment())
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                VStack {
                    TextField("Enter Todo", text: viewStore.binding(get: \.todo.description, send: TodoAction.textFieldChanged))
                        .frame(height: 100)
                        .padding()
                        .onSubmit {
                            viewStore.send(.addTodo)
                        }
                    
                    List {
                        ForEach(Array(viewStore.state.todos.enumerated()), id: \.0) { index, todo in
                            Button(action: { viewStore.send(.todoTapped(index)) }) {
                                Text(todo.description)
                                    .foregroundColor(.black)
                            }
                            .padding(.leading, 12)
                        }
                        .onDelete { indexSet in
                            viewStore.send(.deleteTodo(indexSet))
                        }
                    }
                }
                
                if viewStore.isEditing {
                    VStack {
                        Text("Edit Todo")
                        
                        TextField("Edit Todo", text: viewStore.binding(get: \.todo.description, send: TodoAction.editedTodo))
                            .frame(height: 30)
                            .padding()
                            .onSubmit {
                                viewStore.send(.alertConfirmTapped)
                            }
                        
                        HStack(spacing: 12) {
                            Button(action: { viewStore.send(.alertCancelTapped)}) {
                                Text("Cancel")
                                    .foregroundColor(.red)
                            }
                            
                            Button(action: { viewStore.send(.alertConfirmTapped)}) {
                                Text("Confirm")
                            }
                        }
                    }
                    .frame(width: 300, height: 200)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 2)
                    .zIndex(1)
                }
            }
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView()
    }
}
