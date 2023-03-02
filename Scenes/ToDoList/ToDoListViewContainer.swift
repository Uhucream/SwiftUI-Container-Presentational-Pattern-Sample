import SwiftUI
import CoreData

struct ToDoListViewContainer: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
        entity: ToDo.entity(),
        sortDescriptors: [.init(keyPath: \ToDo.createdAt, ascending: false)],
        animation: .easeInOut
    ) var createdToDos: FetchedResults<ToDo>
    
    @State private var shouldShowCreateToDoViewSheet: Bool = false
    
    func deleteTodo(_ todo: ToDo) -> Void {
        do {
            viewContext.delete(todo)
            
            try viewContext.save()
            
            viewContext.refreshAllObjects()
        } catch {
            print(error)
        }
    }
    
    func toggleDoneStatus(_ todo: ToDo) -> Void {
        do {
            todo.isDone.toggle()
            
            try viewContext.save()

            viewContext.refreshAllObjects()
        } catch {
            print(error)
        }
    }
    
    func showCreateToDoViewSheet() -> Void {
        self.shouldShowCreateToDoViewSheet = true
    }
    
    var body: some View {
        ToDoListView(
            createdToDos: createdToDos
        )
        .onDeleteToDo(action: deleteTodo)
        .onTapMarkAsDoneButton(action: toggleDoneStatus)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button(
                    action: showCreateToDoViewSheet
                ) {
                    Image(systemName: "plus")
                }
                
                if createdToDos.count > 0 {
                    EditButton()
                }
            }
        }
        .navigationTitle("ToDo")
        .sheet(isPresented: $shouldShowCreateToDoViewSheet) {
            NavigationView {
                CreateToDoViewContainer()
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct ToDoListViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ToDoListViewContainer()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
