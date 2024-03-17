//
//  PersonalRecordView.swift
//  GustavWeights
//
//  Created by Dalibor Janeček on 17.03.2024.
//

import SwiftUI

struct PersonalRecordView: View {
    let exercise: Exercise
    
    var weight: Double { get { return getPersonalRecord(weights: exercise.weights) } }
    
    var body: some View {
        Text("PR:\(weight.formattedString(maxDecimalPlaces: 2))KG")
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    func getPersonalRecord(weights: [Weight]) -> Double {
        var pr: Double = 0
        for weight in weights {
            if weight.value > pr {
                pr = weight.value
            }
        }
        return pr
    }
}

extension Double {
    func formattedString(maxDecimalPlaces: Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = maxDecimalPlaces
        return String(formatter.string(from: NSNumber(value: self)) ?? "")
    }
}
