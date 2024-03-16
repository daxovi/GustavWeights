//
//  ExerciseToInspect.swift
//  GustavWeights
//
//  Created by Dalibor Janeček on 16.03.2024.
//

import SwiftUI

struct DetailSheet: View {
    @Bindable var exercise: Exercise
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    
    @State private var showingDialog = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(exercise.weights.sorted { $0.date > $1.date }) { weight in
                    NavigationLink {
                        EditWeightSheet(weight: weight)
                    } label: {
                        HStack {
                            Text(weight.date.formatted(.dateTime.day().month().year()))
                            Spacer()
                            Text(weight.value, format: .number)
                        }
                    }
                }
                Section {
                    NavigationLink {
                        VStack {
                            Form {
                            TextField("name", text: $exercise.name)
                            }

                            Spacer()
                        }
                    } label: {
                        Text("Rename")
                    }

                }
                Section {
                    Button(action: {
                        showingDialog = true
                    }, label: {
                        Text("Delete").foregroundStyle(.red)
                    })
                }
                
                .navigationTitle("\(exercise.name)")
                .navigationBarTitleDisplayMode(.large)
            }
            .toolbar(content: {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                }
            })
            .font(Font.custom("MartianMono-Regular", size: 15))
            .confirmationDialog("opravdu chcete cvik vymazat?",
                                isPresented: $showingDialog,
                                titleVisibility: .visible) {
                Button("Yes, delete", role: .destructive) {
                    context.delete(exercise)
                    dismiss()
                }
                
            }
        }
    }
}
