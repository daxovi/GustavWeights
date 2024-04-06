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
                ForEach(exercise.weights.sorted { $0.date > $1.date }, id: \.self) { weight in
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
                .onDelete { IndexSet in
                    for index in IndexSet {
                        var sortedWeights = exercise.weights.sorted { $0.date > $1.date }
                        sortedWeights.remove(at: index)
                        exercise.weights = sortedWeights
                    }
                }
                Section {
                    NavigationLink {
                        renameExercise
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
    
    var renameExercise: some View {
        VStack {
            Form {
            TextField("name", text: $exercise.name)
            }

            Spacer()
        }
        .toolbar(content: {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Save") {
                    dismiss()
                }
            }
        })
    }
}
