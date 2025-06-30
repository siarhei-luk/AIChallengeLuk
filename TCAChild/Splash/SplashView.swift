//
//  SplashView.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/26/25.
//

import SwiftUI
import ComposableArchitecture

struct SplashView: View {
    @Bindable var store: StoreOf<SplashFeature>
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                SplashBackgroundView()
                
                // Main content
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Logo section
                    SplashLogoView(
                        scale: store.logoScale,
                        opacity: store.logoOpacity
                    )
                    
                    // Title section
                    SplashTitleView(opacity: store.titleOpacity)
                    
                    Spacer()
                    
                    // Loading indicator
                    SplashLoadingView()
                    
                    Spacer(minLength: 60)
                }
            }
            .navigationDestination(isPresented: .init(
                get: { store.shouldNavigateToLogin },
                set: { _ in }
            )) {
                LoginView(store: Store(initialState: LoginFeature.State()) {
                    LoginFeature()
                })
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

// MARK: - Background Component
struct SplashBackgroundView: View {
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.2),
                    Color(red: 0.1, green: 0.05, blue: 0.3),
                    Color(red: 0.2, green: 0.1, blue: 0.4),
                    Color(red: 0.3, green: 0.2, blue: 0.5)
                ],
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
            
            // Floating particles
            SplashParticlesView()
        }
    }
}

// MARK: - Particles Component
struct SplashParticlesView: View {
    @State private var animate1 = false
    @State private var animate2 = false
    @State private var animate3 = false
    
    var body: some View {
        ZStack {
            // Large floating circle
            Circle()
                .fill(Color.white.opacity(0.06))
                .frame(width: 300, height: 300)
                .offset(
                    x: animate1 ? 100 : -100,
                    y: animate1 ? -150 : -50
                )
                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: animate1)
            
            // Medium floating circle
            Circle()
                .fill(Color.blue.opacity(0.08))
                .frame(width: 200, height: 200)
                .offset(
                    x: animate2 ? -80 : 120,
                    y: animate2 ? 200 : 100
                )
                .animation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true), value: animate2)
            
            // Small floating circle
            Circle()
                .fill(Color.purple.opacity(0.1))
                .frame(width: 150, height: 150)
                .offset(
                    x: animate3 ? 150 : -50,
                    y: animate3 ? -200 : 150
                )
                .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: animate3)
        }
        .onAppear {
            animate1.toggle()
            animate2.toggle()
            animate3.toggle()
        }
    }
}

// MARK: - Logo Component
struct SplashLogoView: View {
    let scale: CGFloat
    let opacity: Double
    
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            // Outer ring
            Circle()
                .stroke(Color.white.opacity(0.2), lineWidth: 3)
                .frame(width: 140, height: 140)
                .rotationEffect(.degrees(rotation))
            
            // Inner circle
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 120, height: 120)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                )
            
            // Store icon
            Image(systemName: "storefront")
                .font(.system(size: 50, weight: .ultraLight))
                .foregroundColor(.white)
        }
        .scaleEffect(scale)
        .opacity(opacity)
        .animation(.spring(response: 1.2, dampingFraction: 0.8), value: scale)
        .animation(.easeIn(duration: 0.8), value: opacity)
        .onAppear {
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

// MARK: - Title Component
struct SplashTitleView: View {
    let opacity: Double
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Fake Store")
                .font(.system(size: 36, weight: .thin, design: .rounded))
                .foregroundColor(.white)
                .tracking(2)
            
            Text("Your Shopping Experience")
                .font(.system(size: 16, weight: .light))
                .foregroundColor(.white.opacity(0.8))
                .tracking(1)
        }
        .opacity(opacity)
        .animation(.easeIn(duration: 1.0), value: opacity)
    }
}

// MARK: - Loading Component
struct SplashLoadingView: View {
    @State private var animateLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Custom loading dots
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.white.opacity(0.7))
                        .frame(width: 8, height: 8)
                        .scaleEffect(animateLoading ? 1.0 : 0.5)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                            value: animateLoading
                        )
                }
            }
            
            Text("Loading...")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
                .tracking(1)
        }
        .onAppear {
            animateLoading = true
        }
    }
}

// MARK: - Preview
#Preview {
    SplashView(
        store: Store(initialState: SplashFeature.State()) {
            SplashFeature()
        }
    )
}

