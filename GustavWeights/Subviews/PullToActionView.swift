//
//  PullToAddView.swift
//  GustavWeights
//
//  Created by Dalibor Janeček on 06.04.2024.
//

import SwiftUI

struct PullToActionView: View {

    let screenWidth: CGFloat
    let pullToTrigger: Double = 0.85
    let action: () -> ()
    let maxOffset: CGFloat = -10
    @State var size: Double = 40.0
    @State var offset: CGFloat = 10
    
    var body: some View {
        GeometryReader { geo in
            Color.clear
                .overlay(content: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundStyle(Color("StartColor"))
                        .frame(width: size, height: size)
                        .offset(x: offset)
                        .onTapGesture(perform: action)
                })
                .frame(width: 0)
                .onChange(of: geo.frame(in: .global)) { oldValue, newValue in
                    let position = newValue.minX
                    let portion = position/screenWidth
                    
                    size = pullToTrigger/portion * 80
                    print(portion)
                    offset = mapValue(fromRange: pullToTrigger-0.1...0.9, toRange: -50...maxOffset, value: portion)
                    if portion < pullToTrigger {
                        action()
                    }
                }
        }
    }
    
    func mapValue(fromRange range: ClosedRange<Double>, toRange targetRange: ClosedRange<Double>, value: Double) -> Double {
        let normalizedValue = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        let targetValue = targetRange.lowerBound + normalizedValue * (targetRange.upperBound - targetRange.lowerBound)
        return targetValue
    }
}
