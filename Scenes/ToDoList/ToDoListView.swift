import SwiftUI
import CoreData

struct ToDoListView<ToDosResults: RandomAccessCollection>: View where ToDosResults.Element ==  ToDo {
    
    private var dateFormatter: DateFormatter {
        let formatter: DateFormatter = .init()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        return formatter
    }
    
    private(set) var onTapMarkAsDoneButtonCallback: ((ToDo) -> Void)?
    
    private(set) var onDeleteToDosCallback: ((IndexSet) -> Void)?
    
    var createdToDos: ToDosResults
    
    @ViewBuilder
    func renderToDoCard(_ createdToDo: ToDo) -> some View {
        ToDoListCard(
            isDone: createdToDo.isDone,
            todoTitle: createdToDo.title,
            dueAtDateString: dateFormatter.string(from: createdToDo.dueAt ?? .distantPast),
            onTapMarkAsDoneButton: {
                onTapMarkAsDoneButtonCallback?(createdToDo)
            }
        )
        //  MARK: ↓ 完了ボタン押下後に再レンダリングをかけたいので必要
        .id("\(createdToDo.id)\(createdToDo.isDone)")
    }
    
    func onTapMarkAsDoneButton(action: @escaping (ToDo) -> Void) -> Self {
        var view = self
        
        view.onTapMarkAsDoneButtonCallback = action
        
        return view
    }
    
    func onDeleteToDos(action: @escaping (IndexSet) -> Void) -> Self {
        var view = self
        
        view.onDeleteToDosCallback = action
        
        return view
    }
    
    var body: some View {
        if createdToDos.count == 0 {
            Text("ToDo はありません")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(uiColor: .systemGroupedBackground))
                .edgesIgnoringSafeArea(.all)
        } else {
            List {
                Section {
                    ForEach(createdToDos, id: \.id) { todo in
                        NavigationLink(value: todo) {
                            renderToDoCard(todo)
                                //  .buttonStyle の指定がないと、完了ボタン押下時に行ごと反応してしまう
                                .buttonStyle(.plain)
                                .opacity(todo.isDone ? 0.5 : 1)
                        }
                    }
                    .onDelete(perform: onDeleteToDosCallback)
                }
            }
            .listStyle(.insetGrouped)
        }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView(createdToDos: mockToDos)
    }
}
