//
//  PullToAddView.swift
//  GustavWeights
//
//  Created by Dalibor Janeček on 06.04.2024.
//

import SwiftUI

struct PullToActionView: View {
    let screenWidth: CGFloat
    let pullToTrigger: Double = 0.8
    
    
    var body: some View {
        GeometryReader { geo in
            Color.clear
                .overlay(content: {
                    Color.red
                        .frame(width: 90, height: 10)
                        .offset(x: 100)
                })
                .frame(width: 1)
                .onChange(of: geo.frame(in: .global)) { oldValue, newValue in
                    let position = newValue.minX
                    if (position/screenWidth) < pullToTrigger {
                        print("DEBUG: trigger!")
                    }
                }
        }
    }
}
