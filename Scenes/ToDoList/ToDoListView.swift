import SwiftUI
import CoreData

struct ToDoListView<ToDosResults: RandomAccessCollection>: View where ToDosResults.Element ==  ToDo {
    
    private(set) var onTapMarkAsDoneButtonCallback: ((ToDo) -> Void)?
    
    private(set) var onDeleteToDoCallback: ((IndexSet) -> Void)?
    
    var createdToDos: ToDosResults
    
    @ViewBuilder
    func renderToDoCard(_ createdToDo: ToDo) -> some View {
        ToDoListCard(
            todo: createdToDo,
            todoTitle: createdToDo.title,
            dueAtDate: createdToDo.dueAt ?? .distantPast,
            onTapMarkAsDoneButton: {
                onTapMarkAsDoneButtonCallback?(createdToDo)
            }
        )
    }
    
    func onTapMarkAsDoneButton(action: @escaping (ToDo) -> Void) -> Self {
        var view = self
        
        view.onTapMarkAsDoneButtonCallback = action
        
        return view
    }
    
    func onDeleteToDo(action: @escaping (IndexSet) -> Void) -> Self {
        var view = self
        
        view.onDeleteToDoCallback = action
        
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
                                .buttonStyle(.plain)
                                .opacity(todo.isDone ? 0.5 : 1)
                        }
                    }
                    .onDelete(perform: onDeleteToDoCallback)
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
