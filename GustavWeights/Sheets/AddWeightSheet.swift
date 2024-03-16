//
//  AddWeightSheet.swift
//  GustavWeights
//
//  Created by Dalibor Janeček on 16.03.2024.
//

import SwiftUI

struct AddWeightSheet: View {
    
    @Bindable var exercise: Exercise
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var value: Double?
    
    var body: some View {
        SingleValueEditView(
            textFieldPlaceholder: "Váha",
            buttonLabelText: "Save",
            number: $value) {
            if let value = value {
                let weight = Weight(value: value)
                exercise.weights.append(weight)
            }
            dismiss()
        }
    }
}
