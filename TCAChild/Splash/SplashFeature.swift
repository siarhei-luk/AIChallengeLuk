//
//  SplashFeature.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/26/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct SplashFeature {
    @ObservableState
    struct State: Equatable {
        var isVisible = true
        var logoScale: CGFloat = 0.8
        var logoOpacity: Double = 0.0
        var titleOpacity: Double = 0.0
        var shouldNavigateToLogin = false
    }
    
    enum Action: Equatable {
        case onAppear
        case animateLogo
        case animateTitle
        case navigateToLogin
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    // Start logo animation immediately
                    await send(.animateLogo)
                    
                    // Start title animation after 0.5s
                    try await Task.sleep(for: .seconds(0.5))
                    await send(.animateTitle)
                    
                    // Navigate to login after 4 seconds total
                    try await Task.sleep(for: .seconds(4))
                    await send(.navigateToLogin)
                }
                
            case .animateLogo:
                state.logoScale = 1.0
                state.logoOpacity = 1.0
                return .none
                
            case .animateTitle:
                state.titleOpacity = 1.0
                return .none
                
            case .navigateToLogin:
                state.shouldNavigateToLogin = true
                return .none
            }
        }
    }
}

