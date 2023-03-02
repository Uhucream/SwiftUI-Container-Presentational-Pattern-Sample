//
//  ToDoDetailViewContainer.swift
//  
//  
//  Created by TakashiUshikoshi on 2023/03/02
//  
//

import SwiftUI

struct ToDoDetailViewContainer: View {
    
    @ObservedObject var todo: ToDo
    
    @State private var shouldShowEditToDoViewSheet: Bool = false
    
    var body: some View {
        ToDoDetailView(
            title: $todo.title,
            memo: $todo.memo,
            dueAt: .init(
                get: {
                    return todo.dueAt ?? .distantPast
                },
                set: { _ in
                    
                }
            )
        )
        .navigationTitle("詳細")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(
                    action: {
                        shouldShowEditToDoViewSheet = true
                    }
                ) {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .sheet(isPresented: $shouldShowEditToDoViewSheet) {
            NavigationView {
                EditToDoViewContainer(todo: todo)
            }
        }
    }
}

struct ToDoDetailViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ToDoDetailViewContainer(todo: mockToDos[0])
        }
    }
}
