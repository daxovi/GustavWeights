//
//  GustavWeightsApp.swift
//  GustavWeights
//
//  Created by Dalibor Janeček on 10.03.2024.
//

import SwiftUI
import SwiftData

@main
struct GustavWeightsApp: App {
    
    let container: ModelContainer = {
        let schema = Schema([Exercise.self])
        let container = try! ModelContainer(for: schema, configurations: [])
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
