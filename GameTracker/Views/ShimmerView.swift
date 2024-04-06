//
//  ShimmerView.swift
//  GameTracker
//
//  Created by Henry Wertz on 4/4/24.
//

import SwiftUI

struct ShimmerView: View {
    @State private var isLoading = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.2))
            .frame(width: 88, height: 125)
            .overlay(
                ZStack {
                    Color.white.opacity(0.7)
                    
                    Color.white
                        .mask(
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, .white.opacity(0.5), .clear]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(45))
                            .offset(x: isLoading ? 200 : -200)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    isLoading = true
                }
            }
    }
}
