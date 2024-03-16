//
//  BGImageView.swift
//  GustavWeights
//
//  Created by Dalibor Janeček on 16.03.2024.
//

import SwiftUI

struct BGImageView: View {
    var image: Image
    
    var body: some View {
        GeometryReader(content: { geometry in
            image
                .resizable()
                .scaledToFill()
                .overlay(content: {
                    Color.black.opacity(0.3)
                })
                .ignoresSafeArea()
                .frame(width: geometry.size.width, height: geometry.size.height)
        })
    }
}
