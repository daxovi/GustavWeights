//
//  ExerciseView.swift
//  GustavWeights
//
//  Created by Dalibor Janeček on 06.04.2024.
//

import SwiftUI

struct ExerciseView: View {
    var exercise: Exercise
    var geometry: GeometryProxy
    var lastExercise: Bool = false
    var pullToAction: (()->())?
    
    @State private var plusSize = 0.05
    @State private var position = 0.0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(exercise.name)")
                .offset(getTitleOffset(length: exercise.name.count))
                .font(Font.custom("MartianMono-Bold", size: 500))
                .minimumScaleFactor(0.01)
                .textCase(.uppercase)
                .frame(height: geometry.size.height/3, alignment: .bottom)
            
            Spacer()
            
            PersonalRecordView(exercise: exercise)
                .font(Font.custom("MartianMono-Bold", size: 30))
            
        }
        .padding(30)
        .frame(width: geometry.size.width * (lastExercise ? 1.0 : 0.85))
        .foregroundColor(Color("StartColor"))
        .overlay { if lastExercise { plusToAction } }
    }
    
    var plusToAction: some View {
        GeometryReader { geo in
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundStyle(Color("StartColor"))
                        .frame(width: 40 * (plusSize + 1), height: 40 * (plusSize + 1))
                        .offset(x: (-position) + 30 + (position * 1.5) - position)
                        .onChange(of: geo.frame(in: .global)) { oldValue, newValue in
                            if newValue.minX < 0 {
                                position = newValue.minX
                            } else {
                                position = 0.0
                            }
                            if position < -1 {
                                plusSize = abs(position) / 60
                            } else {
                                plusSize = 0.05
                            }
                            if position < -50 {
                                if let action = pullToAction {
                                        action()
                                }
                            }
                        }
                    Spacer()
                }
            }
        }
    }
    
    func getTitleOffset(length: Int) -> CGSize {
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
