//
//  Exercise.swift
//  GustavWeights
//
//  Created by Dalibor Janeček on 10.03.2024.
//

import Foundation
import SwiftData

@Model
class Exercise {
    var name: String
    var weights: [Weight]
//    var id: UUID
    
    init(name: String) {
        self.name = name
        self.weights = []
 //       self.id = UUID()
    }
}
