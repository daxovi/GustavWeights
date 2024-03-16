//
//  AddExerciseSheet.swift
//  GustavWeights
//
//  Created by Dalibor Janeček on 16.03.2024.
//

import SwiftUI

struct AddExerciseSheet: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    
    var body: some View {
        SingleValueEditView(
            textFieldPlaceholder: "Exercise",
            buttonLabelText: "Add",
            text: $name) {
                    let exercise = Exercise(name: name)
                    context.insert(exercise)
                dismiss()
            }
    }
}
