//
//  ContentView.swift
//  GustavWeights
//
//  Created by Dalibor Janeček on 10.03.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    let buttonHeight:CGFloat = 80.0
    
    // SwiftData
    @Query(sort: \Exercise.name) var exercises: [Exercise]
    @Environment(\.modelContext) var context
    
    @State private var isShowingAddExercise = false
    @State private var isShowingAddWeight = false
    @State private var exerciseToAddWeight: Exercise?
    @State private var exerciseToDetail: Exercise?
    @State private var weightToEdit: Weight?
    @State private var scrolledExercise: Exercise?
    @State private var scrolledToEnd: Bool = false
    
    @AppStorage("loadFirstExercise") private var loadFirstExercise = true
    
    var body: some View {
        GeometryReader(content: { geometry in
            
            ZStack {
                Color.black.ignoresSafeArea()
                
                BGImageView(image: Image("Boxer"))
                
                VStack {
                    HStack(spacing: 5) {
                        ForEach(exercises) {exercise in
                            RoundedRectangle(cornerRadius: 10)
                                .fill( exercise == scrolledExercise ? Color("StartColor") : Color("ResetColor") )
                                .frame(height: 5)
                                
                        }
                    }
                    .padding()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 0) {
                            ForEach(exercises, id: \.self) {exercise in
                                ExerciseView(exercise: exercise, geometry: geometry, lastExercise: (exercise == exercises.last)) {
                                    if !isShowingAddExercise {
                                        isShowingAddExercise.toggle()
                                    }
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .overlay {
                        if exercises.isEmpty {
                            VStack {
                                Text("ADD EXERCISE")
                                    .font(Font.custom("MartianMono-Bold", size: 22))
                                    .padding()
                                Text("to record your lifted weight, add exercise")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.center)
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .onTapGesture(perform: {isShowingAddExercise.toggle()})
                                    .padding()
                                
                            }
                            .padding()
                            .foregroundStyle(Color("StartColor"))
                        }
                    }
                    .task {
                        if exercises.isEmpty && loadFirstExercise {
                            let firstSquat = Exercise(name: "Squat")
                            let firstBench = Exercise(name: "Bench press")
                            let firstDL = Exercise(name: "Dead lift")
                            context.insert(firstSquat)
                            context.insert(firstBench)
                            context.insert(firstDL)
                            loadFirstExercise = false
                        }
                    }
                    .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            if !exercises.isEmpty && !loadFirstExercise {
                                scrolledExercise = exercises[0]
                            }
                        }
                    })
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $scrolledExercise)
                    
                    // SHEETS
                    .sheet(isPresented: $isShowingAddExercise, content: { AddExerciseSheet().presentationDetents([.height(150)]) })
                    .sheet(item: $exerciseToAddWeight, content: { exercise in
                        AddWeightSheet(exercise: exercise).presentationDetents([.height(150)]) })
                    .sheet(item: $weightToEdit, content: { weight in EditWeightSheet(weight: weight) })
                    .sheet(item: $exerciseToDetail, content: { exercise in DetailSheet(exercise: exercise) })
                    
                    if !exercises.isEmpty {
                        buttonBar
                    }
                }
            }
            .font(Font.custom("MartianMono-Regular", size: 15))
            .ignoresSafeArea(edges: .bottom)
        })
    }
    
    var buttonBar: some View {
        HStack(spacing: 0) {
            Button(action: {
                exerciseToAddWeight = scrolledExercise
            }) {
                Color("StopColor")
                    .overlay {
                        Text("ADD WEIGHT")
                    }
                    .frame(height: buttonHeight)
            }
            Button(action: {
                exerciseToDetail = scrolledExercise
            }, label: {
                Color("ResetColor")
                    .overlay {
                        Text("DETAIL")
                    }
                    .frame(height: buttonHeight)
            })
        }
        .foregroundStyle(Color("StartColor"))
    }
}
