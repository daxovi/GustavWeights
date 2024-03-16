//
//  EditExerciseSheet.swift
//  GustavWeights
//
//  Created by Dalibor Janeček on 16.03.2024.
//

import SwiftUI

struct EditExerciseNameSheet: View {
    @Bindable var exercise: Exercise
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        SingleValueEditView(
            textFieldPlaceholder: "Jméno cviku",
            buttonLabelText: "Save",
            text: $exercise.name) {
                dismiss()
            }
    }
}
