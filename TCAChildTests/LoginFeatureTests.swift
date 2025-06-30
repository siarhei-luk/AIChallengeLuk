//
//  LoginFeatureTests.swift
//  TCAChildTests
//
//  Created by Sergey Luk on 6/30/25.
//

import Testing
import ComposableArchitecture
@testable import TCAChild

@MainActor
struct LoginFeatureTests {
    
    @Test
    func usernameAndPasswordChanges() async {
        let store = TestStore(initialState: LoginFeature.State()) {
            LoginFeature()
        }
        
        await store.send(.usernameChanged("testuser")) {
            $0.username = "testuser"
            $0.errorMessage = nil
        }
        
        await store.send(.passwordChanged("password123")) {
            $0.password = "password123"
            $0.errorMessage = nil
        }
    }
    
    @Test
    func togglePasswordVisibility() async {
        let store = TestStore(initialState: LoginFeature.State()) {
            LoginFeature()
        }
        
        await store.send(.togglePasswordVisibility) {
            $0.showPassword = true
        }
    }
    
    @Test
    func loginButtonTappedWithEmptyFields() async {
        let store = TestStore(initialState: LoginFeature.State()) {
            LoginFeature()
        }
        
        await store.send(.loginButtonTapped) {
            $0.errorMessage = "Please enter both username and password"
        }
    }
    
    @Test
    func dismissError() async {
        let store = TestStore(initialState: LoginFeature.State(
            errorMessage: "Some error"
        )) {
            LoginFeature()
        }
        
        await store.send(.dismissError) {
            $0.errorMessage = nil
        }
    }
    
    @Test
    func navigateToStore() async {
        let store = TestStore(initialState: LoginFeature.State()) {
            LoginFeature()
        }
        
        await store.send(.navigateToStore) {
            $0.shouldNavigateToStore = true
        }
    }
    
    @Test
    func networkStatusChanges() async {
        let store = TestStore(initialState: LoginFeature.State()) {
            LoginFeature()
        }
        
        await store.send(.networkStatusChanged(false)) {
            $0.isConnected = false
            $0.showConnectivityBanner = true
        }
        
        await store.send(.networkStatusChanged(true)) {
            $0.isConnected = true
            $0.showConnectivityBanner = false
        }
    }
    
    @Test
    func dismissConnectivityBanner() async {
        let store = TestStore(initialState: LoginFeature.State(
            showConnectivityBanner: true
        )) {
            LoginFeature()
        }
        
        await store.send(.dismissConnectivityBanner) {
            $0.showConnectivityBanner = false
        }
    }
}

