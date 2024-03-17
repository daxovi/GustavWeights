//
//  EditWeightSheet.swift
//  GustavWeights
//
//  Created by Dalibor Janeček on 16.03.2024.
//

import SwiftUI

struct EditWeightSheet: View {
    @Bindable var weight: Weight
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
        
    @State private var value: Double = 0
    var body: some View {
        NavigationStack {
                Form {
                    TextField("Váha", value: $weight.value, format: .number)
                        .keyboardType(.decimalPad)
                }
            
            .navigationTitle("Edit weight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                }
            })
        }
    }
}
