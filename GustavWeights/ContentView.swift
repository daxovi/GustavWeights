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
    
    @Query(sort: \Exercise.name) var exercises: [Exercise]
    
    @State private var isShowingAddExercise = false
    @State private var isShowingAddWeight = false
    @State private var exerciseToAddWeight: Exercise?
    @State private var exerciseToDetail: Exercise?
    @State private var weightToEdit: Weight?
    @State private var scrolledExercise: Exercise?
    @State private var scrolledToEnd: Bool = false

    var body: some View {
        GeometryReader(content: { geometry in
            
            ZStack {
                Color.black.ignoresSafeArea()
                
                BGImageView(image: Image("Boxer"))
                
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(exercises, id: \.self) {exercise in
                                ExerciseView(exercise: exercise, geometry: geometry, lastExercise: (exercise == exercises.last)) {
                                    if !isShowingAddExercise {
                                        isShowingAddExercise.toggle()
                                    }
                                }
                            }
                            /*
                            PullToActionView(screenWidth: geometry.size.width) {
                                if !isShowingAddExercise {
                                    isShowingAddExercise.toggle()
                                }
                            }
                             */
                        }
                        .scrollTargetLayout()
                    }
                    .onAppear(perform: { scrolledExercise = exercises[0] })
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $scrolledExercise)
                    // SHEETS
                    .sheet(isPresented: $isShowingAddExercise, content: { AddExerciseSheet().presentationDetents([.fraction(0.2)]) })
                    .sheet(item: $exerciseToAddWeight, content: { exercise in
                        AddWeightSheet(exercise: exercise).presentationDetents([.fraction(0.2)]) })
                    .sheet(item: $weightToEdit, content: { weight in EditWeightSheet(weight: weight) })
                    .sheet(item: $exerciseToDetail, content: { exercise in DetailSheet(exercise: exercise) })
                    
                    buttonBar
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

#Preview {
    ContentView()
}
