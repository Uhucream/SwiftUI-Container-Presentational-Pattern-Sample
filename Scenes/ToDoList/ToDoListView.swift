import SwiftUI
import CoreData

struct ToDoListView<ToDosResults: RandomAccessCollection>: View where ToDosResults.Element ==  ToDo {
    
    @Environment(\.editMode) var editMode
    
    @State private var shouldShowDoneToDos: Bool = false
    
    @State private var linkOpacity: Double = 1.0
    
    private(set) var onTapToDoListCardCallback: ((ToDo) -> Void)?
    
    private(set) var onTapMarkAsDoneButtonCallback: ((ToDo) -> Void)?
    
    private(set) var onDeleteToDoCallback: ((ToDo) -> Void)?
    
    private var isEditingMode: Bool {
        return editMode?.wrappedValue.isEditing ?? false
    }
    
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
    
    func onTapToDoListCard(action: @escaping (ToDo) -> Void) -> Self {
        var view = self
        
        view.onTapToDoListCardCallback = action
        
        return view
    }
    
    func onTapMarkAsDoneButton(action: @escaping (ToDo) -> Void) -> Self {
        var view = self
        
        view.onTapMarkAsDoneButtonCallback = action
        
        return view
    }
    
    func onDeleteToDo(action: @escaping (ToDo) -> Void) -> Self {
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
            let undoneToDos: [ToDo] = createdToDos.filter { todo in !todo.isDone }
            
            let doneToDos: [ToDo] = createdToDos.filter { todo in todo.isDone }
            
            List {
                Section {
                    if undoneToDos.count == 0 {
                        Text("未完了の項目はありません")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .listRowBackground(Color(uiColor: .systemGroupedBackground))
                    } else {
                        ForEach(Array(undoneToDos.enumerated()), id: \.element.id) { (index, undoneToDo) in
                            NavigationLink(value: undoneToDo) {
                                renderToDoCard(undoneToDo)
                                    .buttonStyle(.plain)
                            }
                        }
                        .onDelete { deleteTargetsOffsets in
                            let deleteTargets: [ToDo] = deleteTargetsOffsets
                                .map { offset in
                                    return undoneToDos[offset]
                                }
                            
                            deleteTargets
                                .forEach { deleteTarget in
                                    onDeleteToDoCallback?(deleteTarget)
                                }
                        }
                    }
                } header: {
                    Text("未完了の項目")
                        .font(.footnote)
                }
                
                if doneToDos.count > 0 {
                    Section {
                        ForEach(Array(doneToDos.enumerated()), id: \.element.id ) { (index, doneToDo) in
                            NavigationLink(value: doneToDo) {
                                renderToDoCard(doneToDo)
                                    .buttonStyle(.plain)
                            }
                        }
                        .onDelete { deleteTargetsOffsets in
                            let deleteTargets: [ToDo] = deleteTargetsOffsets
                                .map { offset in
                                    return doneToDos[offset]
                                }
                            
                            deleteTargets
                                .forEach { deleteTarget in
                                    onDeleteToDoCallback?(deleteTarget)
                                }
                        }
                    } header: {
                        Text("実行済みの項目")
                            .font(.footnote)
                    }
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
