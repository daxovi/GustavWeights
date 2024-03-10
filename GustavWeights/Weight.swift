//
//  Weight.swift
//  GustavWeights
//
//  Created by Dalibor Janeček on 10.03.2024.
//

import Foundation
import SwiftData

@Model
class Weight {
    var date: Date
    var value: Double
    
    init(value: Double) {
        self.date = .now
        self.value = value
    }
}
