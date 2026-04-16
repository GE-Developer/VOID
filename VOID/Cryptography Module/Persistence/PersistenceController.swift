//
//  PersistenceController.swift
//  VOID
//
//  Created by GE-Developer
//

import CoreData

/// Обёртка над `NSPersistentContainer`. Даёт доступ к `viewContext` и
/// создаёт in-memory стек для preview/тестов.
struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "VOIDModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error {
                assertionFailure("Core Data load error: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
