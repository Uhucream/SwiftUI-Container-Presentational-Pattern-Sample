//
//  CreateToDoViewContainer.swift
//  
//  
//  Created by TakashiUshikoshi on 2023/03/02
//  
//

import SwiftUI
import Combine

struct CreateToDoViewContainer: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    
    @State private var dueAt: Date = .now
    
    @State private var memo: String = ""
    
    @State private var shouldEnableSaveButton: Bool = false
    
    func saveInputValues() -> Void {
        do {
            let todo: ToDo = .init(
                on: viewContext,
                title: title,
                memo: memo,
                dueAt: dueAt
            )
            
            try viewContext.save()
            
            viewContext.refresh(todo, mergeChanges: true)
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        CreateToDoView(
            title: $title,
            dueAt: $dueAt,
            memo: $memo,
            shouldEnableSaveButton: $shouldEnableSaveButton
        )
        .onTapDismissButton {
            dismiss()
        }
        .onTapSaveButton {
            saveInputValues()
            
            dismiss()
        }
        .onReceive(Just(title)) { newTitle in
            let isNotEmptyTitle: Bool = newTitle.count > 0
            
            shouldEnableSaveButton = isNotEmptyTitle
        }
    }
}

struct CreateToDoViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("hoge")
        }
        .sheet(isPresented: .constant(true)) {
            NavigationView {
                CreateToDoViewContainer()
                    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            }
        }
    }
}
