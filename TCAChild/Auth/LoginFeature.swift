//
//  LoginFeature.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/26/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct LoginFeature {
    @ObservableState
    struct State {
        var username = ""
        var password = ""
        var isLoading = false
        var isLoginSuccessful = false
        var errorMessage: String?
        var showPassword = false
        var authToken: String = ""
        var shouldNavigateToStore = false
        var isConnected = true
        var showConnectivityBanner = false
    }
    
    enum Action {
        case usernameChanged(String)
        case passwordChanged(String)
        case togglePasswordVisibility
        case loginButtonTapped
        case loginResponse(Result<AuthResponse, Error>)
        case dismissError
        case navigateToStore
        case networkStatusChanged(Bool)
        case startNetworkMonitoring
        case dismissConnectivityBanner
    }
    
    @Dependency(\.apiService) var apiService
    @Dependency(\.networkMonitor) var networkMonitor
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .usernameChanged(username):
                state.username = username
                state.errorMessage = nil
                return .none
                
            case let .passwordChanged(password):
                state.password = password
                state.errorMessage = nil
                return .none
                
            case .togglePasswordVisibility:
                state.showPassword.toggle()
                return .none
                
            case .loginButtonTapped:
                guard !state.username.isEmpty, !state.password.isEmpty else {
                    state.errorMessage = "Please enter both username and password"
                    return .none
                }
                
                state.isLoading = true
                state.errorMessage = nil
                
                return .run { [username = state.username, password = state.password] send in
                    await send(.loginResponse(
                        Result {
                            try await apiService.authUser(username: username, password: password)
                        }
                    ))
                }
                
            case let .loginResponse(.success(response)):
                state.isLoading = false
                state.isLoginSuccessful = true
                state.authToken = response.token
                return .run { send in
                    await send(.navigateToStore)
                }
            case .navigateToStore:
                state.shouldNavigateToStore = true
                return .none
            case let .loginResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
                
            case .dismissError:
                state.errorMessage = nil
                return .none
            case .startNetworkMonitoring:
                return .run { send in
                    for await isConnected in await networkMonitor.startMonitoring() {
                        await send(.networkStatusChanged(isConnected))
                    }
                }
                
            case let .networkStatusChanged(isConnected):
                let wasDisconnected = !state.isConnected
                state.isConnected = isConnected
                
                if !isConnected {
                    // Show error banner when disconnected
                    state.showConnectivityBanner = true
                    // Cancel any ongoing login request
                    if state.isLoading {
                        state.isLoading = false
                        state.errorMessage = "No internet connection. Please check your network and try again."
                    }
                } else if wasDisconnected && isConnected {
                    // Hide banner when reconnected
                    state.showConnectivityBanner = false
                    // Clear network-related error messages
                    if state.errorMessage?.contains("internet") == true ||
                       state.errorMessage?.contains("network") == true {
                        state.errorMessage = nil
                    }
                }
                return .none
                
            case .dismissConnectivityBanner:
                state.showConnectivityBanner = false
                return .none
            }
        }._printChanges()
    }
}

extension LoginFeature.State: Equatable {}
extension LoginFeature.Action: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.usernameChanged(lhsUsername), .usernameChanged(rhsUsername)):
            return lhsUsername == rhsUsername
            
        case let (.passwordChanged(lhsPassword), .passwordChanged(rhsPassword)):
            return lhsPassword == rhsPassword
            
        case (.togglePasswordVisibility, .togglePasswordVisibility):
            return true
            
        case (.loginButtonTapped, .loginButtonTapped):
            return true
            
        case let (.loginResponse(lhsResult), .loginResponse(rhsResult)):
            switch (lhsResult, rhsResult) {
            case let (.success(lhsResponse), .success(rhsResponse)):
                return lhsResponse == rhsResponse
            case let (.failure(lhsError), .failure(rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            default:
                return false
            }
            
        case (.dismissError, .dismissError):
            return true
            
        case (.navigateToStore, .navigateToStore):
            return true
            
        case let (.networkStatusChanged(lhsConnected), .networkStatusChanged(rhsConnected)):
            return lhsConnected == rhsConnected
            
        case (.startNetworkMonitoring, .startNetworkMonitoring):
            return true
            
        case (.dismissConnectivityBanner, .dismissConnectivityBanner):
            return true
            
        default:
            return false
        }
    }
}
