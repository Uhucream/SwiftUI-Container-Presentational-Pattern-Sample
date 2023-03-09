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
    
    var isDone: Bool
    var todoTitle: String
    var dueAtDateString: String
    
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
                        if isDone {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else {
                            Image(systemName: "circlebadge")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .foregroundColor(isDone ? .accentColor : .gray)
                    .frame(maxHeight: 24)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todoTitle)
                
                Text("期日: \(dueAtDateString)")
                    .font(.caption)
            }
        }
    }
}

struct ToDoListCard_Previews: PreviewProvider {
    static var previews: some View {
        let dateFormatter: DateFormatter = {
            let formatter: DateFormatter = .init()
            
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            
            return formatter
        }()
        
        ToDoListCard(
            isDone: false,
            todoTitle: "プレビューTodo",
            dueAtDateString: dateFormatter.string(from: .now.addingTimeInterval(10000))
        )
        .previewLayout(.sizeThatFits)
    }
}
