import Foundation
import CoreData

@objc(ToDo)
class ToDo: NSManagedObject {
    @NSManaged var title: String
    @NSManaged var memo: String
    @NSManaged var isDone: Bool
    @NSManaged var createdAt: Date
    @NSManaged var dueAt: Date?
}

extension ToDo: Identifiable {
    var id: UUID {
        .init()
    }
    
    static var entityDescription: NSEntityDescription {
        let description: NSEntityDescription = .init()

        description.name = String(describing: Self.self)
        description.managedObjectClassName = NSStringFromClass(Self.self)
        
        description.properties = [
            {
                $0.name = "title"
                $0.attributeType = .stringAttributeType
                $0.isOptional = false
                
                $0.defaultValue = "タイトル未設定"

                return $0
            }(NSAttributeDescription()),
            {
                $0.name = "memo"
                $0.attributeType = .stringAttributeType
                $0.isOptional = false
                
                $0.defaultValue = ""

                return $0
            }(NSAttributeDescription()),
            {
                $0.name = "isDone"
                $0.attributeType = .booleanAttributeType
                $0.isOptional = false

                $0.defaultValue = false

                return $0
            }(NSAttributeDescription()),
            {
                $0.name = "createdAt"
                $0.attributeType = .dateAttributeType
                $0.isOptional = false

                $0.defaultValue = Date.now

                return $0
            }(NSAttributeDescription()),
            {
                $0.name = "dueAt"
                $0.attributeType = .dateAttributeType
                $0.isOptional = true

                return $0
            }(NSAttributeDescription()),
        ]

        return description
    }
}

fileprivate let viewContext: NSManagedObjectContext = PersistenceController.preview.container.viewContext

let mockToDos: [ToDo] = [
    .init(
        on: viewContext,
        title: "test",
        memo: "めもめも",
        dueAt: .now.addingTimeInterval(100000)
    )
]
