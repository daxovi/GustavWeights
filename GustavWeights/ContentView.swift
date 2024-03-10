//
//  ContentView.swift
//  GustavWeights
//
//  Created by Dalibor Janeček on 10.03.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var isShowingAddExercise = false
    @State private var isShowingAddWeight = false
    @State private var exerciseToAddWeight: Exercise?
    @State private var exerciseToEdit: Exercise?
    @State private var weightToEdit: Weight?
    
    @Query(sort: \Exercise.name) var exercises: [Exercise]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(exercises) {exercise in
                    Section("\(exercise.name)") {
                        ForEach(exercise.weights) { weight in
                            HStack {
                                Text(weight.date.formatted(.dateTime.day().month().year()))
                                Spacer()
                                Text(weight.value, format: .number)
                            }
                            .onTapGesture {
                                weightToEdit = weight
                            }
                        }
                        Button(action: {
                            exerciseToAddWeight = exercise
                        }, label: {
                            Text("Přidej \(exercise.name)")
                        })
                        Button(action: {
                            exerciseToEdit = exercise
                        }, label: {
                            Text("Uprav \(exercise.name)")
                        })
                    }
                }
            }
            .navigationTitle("Weights")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingAddExercise, content: { AddExerciseSheet() })
            .sheet(item: $exerciseToAddWeight, content: { exercise in
                AddWeightSheet(exercise: exercise)
            })
            .sheet(item: $exerciseToEdit, content: { exercise in
                EditExerciseSheet(exercise: exercise)
            })
            .sheet(item: $weightToEdit, content: { weight in
                EditWeightSheet(weight: weight)
            })
            .toolbar(content: {
                Button(action: {
                    isShowingAddExercise.toggle()
                }, label: {
                    Text("přidej cviky")
                })
            })
        }
    }
}

struct AddExerciseSheet: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Jméno cviku", text: $name)
            }
            .navigationTitle("Add exercise")
            .navigationBarTitleDisplayMode(.large)
            .toolbar(content: {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        let exercise = Exercise(name: name)
                        context.insert(exercise)
                        dismiss()
                    }
                    Button("Cancel") { dismiss() }
                }
            })
        }
    }
}

struct EditExerciseSheet: View {
    @Bindable var exercise: Exercise
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Jméno cviku", text: $exercise.name)
            }
            .navigationTitle("Edit exercise")
            .navigationBarTitleDisplayMode(.large)
            .toolbar(content: {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                    Button("Delete") {
                        context.delete(exercise)
                        dismiss()
                    }
                }
            })
        }
    }
}

struct AddWeightSheet: View {
    @Bindable var exercise: Exercise
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var value: Double = 0
    var body: some View {
        NavigationStack {
            Form {
                TextField("Váha", value: $value, format: .number)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add weight")
            .navigationBarTitleDisplayMode(.large)
            .toolbar(content: {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        let weight = Weight(value: value)
                        exercise.weights.append(weight)
                        dismiss()
                    }
                    Button("Cancel") { dismiss() }
                }
            })
        }
    }
}

struct EditWeightSheet: View {
    @Bindable var weight: Weight
    @Environment(\.dismiss) private var dismiss
    
    @State private var value: Double = 0
    var body: some View {
        NavigationStack {
            Form {
                TextField("Váha", value: $weight.value, format: .number)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add weight")
            .navigationBarTitleDisplayMode(.large)
            .toolbar(content: {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                    Button("Cancel") { dismiss() }
                }
            })
        }
    }
}

#Preview {
    ContentView()
}
