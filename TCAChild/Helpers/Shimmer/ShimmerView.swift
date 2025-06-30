//
//  ShimmerView.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/20/25.
//

import SwiftUI

struct ShimmerView: View {
    @State private var isAnimating = false
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.clear,
                Color.white.opacity(0.4),
                Color.clear
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .mask(
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .black, location: 0.3),
                            .init(color: .black, location: 0.7),
                            .init(color: .clear, location: 1)
                        ]),
                        startPoint: isAnimating ? .trailing : .leading,
                        endPoint: isAnimating ? UnitPoint(x: 1.5, y: 0) : UnitPoint(x: -0.5, y: 0)
                    )
                )
        )
        .onAppear {
            withAnimation(
                Animation
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
            ) {
                isAnimating = true
            }
        }
    }
}

extension View {
    func shimmer() -> some View {
        overlay(ShimmerView())
    }
}
