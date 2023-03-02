//
//  ToDo+.swift
//  
//  
//  Created by TakashiUshikoshi on 2023/03/02
//  
//

import Foundation
import CoreData

extension ToDo {
    convenience init(
        on context: NSManagedObjectContext,
        title: String,
        memo: String,
        dueAt: Date
    ) {
        self.init(context: context)
        
        self.title = title
        self.memo = memo
        self.dueAt = dueAt
    }
}
