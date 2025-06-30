//
//  TCAChildApp.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/18/25.
//

import SwiftUI
import ComposableArchitecture
import SwiftData

@main
struct TCAChildApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView(store: Store(initialState: SplashFeature.State(), reducer: {
                SplashFeature()
            }))
        }
        .modelContainer(for: [ProductDataModel.self])
    }
}
