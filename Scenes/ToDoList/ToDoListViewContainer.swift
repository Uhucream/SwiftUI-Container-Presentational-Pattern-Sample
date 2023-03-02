import SwiftUI
import CoreData

struct ToDoListViewContainer: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
        entity: ToDo.entity(),
        sortDescriptors: [.init(keyPath: \ToDo.createdAt, ascending: false)]
    ) var createdToDos: FetchedResults<ToDo>
    
    @State private var shouldShowCreateToDoViewSheet: Bool = false
    
    @State private var shouldShowToDoDetailView: Bool = false
    
    @State private var detailDisplayTargetToDo: ToDo? = nil
    
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
    
    func navigateToDetailView(todo: ToDo) -> Void {
        self.detailDisplayTargetToDo = todo
        
        self.shouldShowToDoDetailView = true
    }
    
    func showCreateToDoViewSheet() -> Void {
        self.shouldShowCreateToDoViewSheet = true
    }
    
    var body: some View {
        ToDoListView(
            createdToDos: createdToDos
        )
        .onTapToDoListCard(action: navigateToDetailView)
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
