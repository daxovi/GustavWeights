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
    
    var body: some View {
        GeometryReader(content: { geometry in
            
            ZStack {
                Color.black.ignoresSafeArea()
                
                BGImageView(image: Image("Boxer"))
                
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(exercises, id: \.self) {exercise in
                                VStack(alignment: .leading) {
                                    Text("\(exercise.name)")
                                        .offset(getOffset(length: exercise.name.count))
                                        .font(Font.custom("MartianMono-Bold", size: 500))
                                        .minimumScaleFactor(0.01)
                                        .textCase(.uppercase)
                                        .frame(height: geometry.size.height/3, alignment: .bottom)
                                    
                                    Spacer()
                                    Text("PR 00KG")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(Font.custom("MartianMono-Bold", size: 30))
                                }
                                .padding(30)
                                .frame(width: geometry.size.width * 0.85)
                                .foregroundColor(Color("StartColor"))
                            }
                            Button(action: {
                                isShowingAddExercise.toggle()
                            }, label: {
                                Text("Add exercise")
                            })
                        }
                        .scrollTargetLayout()
                    }
                    .onAppear(perform: { scrolledExercise = exercises[0] })
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $scrolledExercise)
                    .font(Font.custom("MartianMono-Regular", size: 15))
                    .sheet(isPresented: $isShowingAddExercise, content: { AddExerciseSheet().presentationDetents([.fraction(0.2)]) })
                    .sheet(item: $exerciseToAddWeight, content: { exercise in                         AddWeightSheet(exercise: exercise).presentationDetents([.fraction(0.2)]) })
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
                        Text("ADD \(scrolledExercise?.name ?? "")")
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
    }
    
    func getOffset(length: Int) -> CGSize {
        switch length {
        case 0...3:
            return CGSize(width: -15, height: 30)
        case 4:
            return CGSize(width: -10, height: 20)
        case 5...7:
            return CGSize(width: -5, height: 5)
        default:
            return CGSizeZero
        }
    }
}

#Preview {
    ContentView()
}
