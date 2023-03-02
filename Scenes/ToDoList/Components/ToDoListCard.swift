//
//  ToDoListCard.swift
//  
//  
//  Created by TakashiUshikoshi on 2023/03/02
//  
//

import SwiftUI

struct ToDoListCard: View {
    
    @Environment(\.editMode) var editMode
    
    private var dateFormatter: DateFormatter {
        let formatter: DateFormatter = .init()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        return formatter
    }
    
    @ObservedObject var todo: ToDo
    
    var todoTitle: String
    var dueAtDate: Date
    
    var onTapMarkAsDoneButton: (() -> Void)?
    
    var body: some View {
        HStack {
            if !(editMode?.wrappedValue.isEditing ?? false) {
                Button(
                    action: {
                        onTapMarkAsDoneButton?()
                    }
                ) {
                    ZStack {
                        if todo.isDone {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else {
                            Image(systemName: "circlebadge")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .foregroundColor(todo.isDone ? .accentColor : .gray)
                    .frame(maxHeight: 24)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todoTitle)
                
                Text("期日: \(dateFormatter.string(from: dueAtDate))")
                    .font(.caption)
            }
        }
    }
}

struct ToDoListCard_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListCard(
            todo: mockToDos[0],
            todoTitle: "プレビューTodo",
            dueAtDate: .now.addingTimeInterval(10000)
        )
        .previewLayout(.sizeThatFits)
    }
}