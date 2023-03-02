//
//  ToDoDetailView.swift
//  
//  
//  Created by TakashiUshikoshi on 2023/03/02
//  
//

import SwiftUI

struct ToDoDetailView: View {

    @Binding var title: String
    @Binding var memo: String
    
    @Binding var dueAt: Date
    
    var body: some View {
        List {
            Section {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
            }
            .listRowBackground(Color(uiColor: .systemGroupedBackground))

            Section {
                HStack {
                    Text("期日:")
                    
                    Text(dueAt, style: .date)
                }
            }
            .listRowBackground(Color(uiColor: .systemGroupedBackground))
            
            Section {
                VStack(alignment: .leading) {
                    Text("メモ")
                        .font(.caption)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(uiColor: .systemFill))
                        .frame(maxWidth: .infinity)
                        .aspectRatio(16 / 9, contentMode: .fit)
                        .overlay {
                            Text(memo)
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        }
                }
            }
            .listRowBackground(Color(uiColor: .systemGroupedBackground))
        }
    }
}

struct ToDoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoDetailView(
            title: .constant("明日までにやる"),
            memo: .constant("めもめも"),
            dueAt: .constant(.now.addingTimeInterval(100000))
        )
    }
}
