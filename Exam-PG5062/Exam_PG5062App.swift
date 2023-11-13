//
//  Exam_PG5062App.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 13/11/2023.
//

import SwiftUI

@main
struct Exam_PG5062App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
