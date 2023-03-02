//
//  EditToDoViewContainer.swift
//  
//  
//  Created by TakashiUshikoshi on 2023/03/02
//  
//

import SwiftUI
import Combine

struct EditToDoViewContainer: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    var todo: ToDo
    
    @State private var title: String
    
    @State private var dueAt: Date
    
    @State private var memo: String
    
    @State private var shouldEnableSaveChangesButton: Bool = false
    
    init(todo: ToDo) {
        self.todo = todo
        
        _title = .init(initialValue: todo.title)
        _dueAt = .init(initialValue: todo.dueAt ?? .distantPast)
        _memo = .init(initialValue: todo.memo)
    }
    
    func updateToDo() -> Void {
        do {
            todo.title = self.title
            todo.dueAt = self.dueAt
            todo.memo = self.memo
            
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        EditToDoView(
            title: $title,
            dueAt: $dueAt,
            memo: $memo,
            shouldEnableSaveChangesButton: $shouldEnableSaveChangesButton
        )
        .onTapDismissButton {
            dismiss()
        }
        .onTapSaveChangesButton {
            updateToDo()
            
            dismiss()
        }
        .onReceive(
            Just(title)
                .combineLatest(
                    Just(dueAt),
                    Just(memo)
                )
        ) { newTitle, newDueAt, newMemo in
            let isTitleChanged: Bool = newTitle != todo.title
            
            let isDueAtChanged: Bool = !Calendar.current.isDate(newDueAt, equalTo: todo.dueAt ?? .distantPast, toGranularity: .minute)
            
            let isMemoChanged: Bool = newMemo != todo.memo
            
            shouldEnableSaveChangesButton = isTitleChanged || isDueAtChanged || isMemoChanged
        }
    }
}

struct EditToDoViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        EditToDoViewContainer(todo: mockToDos[0])
    }
}
