import SwiftUI
import CoreData

struct ToDoListViewContainer: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
        entity: ToDo.entity(),
        sortDescriptors: [.init(keyPath: \ToDo.createdAt, ascending: false)]
    ) var createdToDos: FetchedResults<ToDo>
    
    @State private var shouldShowCreateToDoViewSheet: Bool = false
    
    func deleteTodos(_ targetsOffsets: IndexSet) -> Void {
        do {
            let deleteTargets: [ToDo] = targetsOffsets
                .map { targetOffset in
                    return createdToDos[targetOffset]
                }
            
            deleteTargets
                .forEach { deleteTarget in
                    viewContext.delete(deleteTarget)
                }
            
            
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
        .onDeleteToDos(action: deleteTodos)
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
        .navigationDestination(for: ToDo.self) { todo in
            ToDoDetailViewContainer(todo: todo)
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
