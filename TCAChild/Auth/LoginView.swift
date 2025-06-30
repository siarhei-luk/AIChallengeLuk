//
//  LoginView.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/26/25.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    @Bindable var store: StoreOf<LoginFeature>
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    if store.showConnectivityBanner {
                        ConnectivityBanner(
                            isConnected: store.isConnected) {
                                store.send(.dismissConnectivityBanner)
                            }
                    }
                    ZStack {
                        LoginBackgroundView(isLoading: store.isLoading)
                        
                        ScrollView {
                            VStack(spacing: 0) {
                                Spacer(minLength: geometry.size.height * 0.1)
                                
                                LoginHeaderView(isLoginSuccessful: store.isLoginSuccessful)
                                    .padding(.bottom, 50)
                                
                                LoginFormView(store: store)
                                    .padding(.horizontal, 32)
                                
                                Spacer(minLength: geometry.size.height * 0.1)
                            }
                        }
                    }
                }
            }
            .navigationDestination(isPresented: .init(
                get: { store.shouldNavigateToStore },
                set: { _ in }
            )) {
                StoreView(store: Store(initialState: StoreFeature.State(), reducer: {
                    StoreFeature()
                }))
            }
        }
        .onAppear {
            store.send(.startNetworkMonitoring)
        }
        .navigationBarBackButtonHidden()
        .alert("Login Error", isPresented: .constant(store.errorMessage != nil)) {
            Button("OK") {
                store.send(.dismissError)
            }
        } message: {
            if let errorMessage = store.errorMessage {
                Text(errorMessage)
            }
        }
    }
}

// MARK: - Background Component
struct LoginBackgroundView: View {
    let isLoading: Bool
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.3),
                    Color(red: 0.2, green: 0.1, blue: 0.4),
                    Color(red: 0.3, green: 0.2, blue: 0.5)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Floating shapes
            FloatingShapesView(isLoading: isLoading)
        }
    }
}

// MARK: - Floating Shapes Component
struct FloatingShapesView: View {
    let isLoading: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 200, height: 200)
                .offset(x: -100, y: -300)
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isLoading)
            
            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 150, height: 150)
                .offset(x: 150, y: -200)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: isLoading)
        }
    }
}

// MARK: - Header Component
struct LoginHeaderView: View {
    let isLoginSuccessful: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            LoginLogoView(isLoginSuccessful: isLoginSuccessful)
            LoginTitleView()
        }
    }
}

// MARK: - Logo Component
struct LoginLogoView: View {
    let isLoginSuccessful: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 100, height: 100)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                )
            
            Image(systemName: "storefront")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(.white)
        }
        .scaleEffect(isLoginSuccessful ? 1.2 : 1.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isLoginSuccessful)
    }
}

// MARK: - Title Component
struct LoginTitleView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Welcome Back")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Sign in to your Fake Store account")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Form Component
struct LoginFormView: View {
    @Bindable var store: StoreOf<LoginFeature>
    
    var body: some View {
        VStack(spacing: 24) {
            UsernameFieldView(
                username: store.username,
                isLoading: store.isLoading,
                onUsernameChanged: { username in
                    store.send(.usernameChanged(username))
                }
            )
            
            PasswordFieldView(
                password: store.password,
                showPassword: store.showPassword,
                isLoading: store.isLoading,
                onPasswordChanged: { password in
                    store.send(.passwordChanged(password))
                },
                onToggleVisibility: {
                    store.send(.togglePasswordVisibility)
                }
            )
            
            LoginButtonView(
                isLoading: store.isLoading,
                isLoginSuccessful: store.isLoginSuccessful,
                onLogin: {
                    store.send(.loginButtonTapped)
                }
            )
            
            if store.isLoginSuccessful {
                LoginSuccessView(authToken: store.authToken)
            }
            
            DemoCredentialsView()
                .padding(.top, 16)
        }
    }
}

// MARK: - Username Field Component
struct UsernameFieldView: View {
    let username: String
    let isLoading: Bool
    let onUsernameChanged: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Username")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.9))
            
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.white.opacity(0.7))
                    .frame(width: 20)
                
                TextField("Enter your username", text: .init(
                    get: { username },
                    set: onUsernameChanged
                ))
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(.white)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .disabled(isLoading)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(isLoading ? 0.05 : 0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            )
            .opacity(isLoading ? 0.6 : 1.0)
        }
    }
}

// MARK: - Password Field Component
struct PasswordFieldView: View {
    let password: String
    let showPassword: Bool
    let isLoading: Bool
    let onPasswordChanged: (String) -> Void
    let onToggleVisibility: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Password")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.9))
            
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.white.opacity(0.7))
                    .frame(width: 20)
                
                Group {
                    if showPassword {
                        TextField("Enter your password", text: .init(
                            get: { password },
                            set: onPasswordChanged
                        ))
                    } else {
                        SecureField("Enter your password", text: .init(
                            get: { password },
                            set: onPasswordChanged
                        ))
                    }
                }
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(.white)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .disabled(isLoading)
                
                Button(action: onToggleVisibility) {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .foregroundColor(.white.opacity(0.7))
                }
                .disabled(isLoading)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(isLoading ? 0.05 : 0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            )
            .opacity(isLoading ? 0.6 : 1.0)
        }
    }
}

// MARK: - Login Button Component
struct LoginButtonView: View {
    let isLoading: Bool
    let isLoginSuccessful: Bool
    let onLogin: () -> Void
    
    var body: some View {
        Button(action: onLogin) {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                    
                    Text("Signing In...")
                        .fontWeight(.semibold)
                } else if isLoginSuccessful {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("Success!")
                        .fontWeight(.semibold)
                } else {
                    Text("Sign In")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(buttonBackground)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(
                color: isLoginSuccessful ? .green.opacity(0.3) : .blue.opacity(0.3),
                radius: 8,
                x: 0,
                y: 4
            )
        }
        .disabled(isLoading)
        .opacity(isLoading ? 0.7 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isLoginSuccessful)
    }
    
    private var buttonBackground: some View {
        Group {
            if isLoginSuccessful {
                LinearGradient(
                    colors: [Color.green, Color.green.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            } else {
                LinearGradient(
                    colors: [Color.blue, Color.purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            }
        }
    }
}

// MARK: - Success Message Component
struct LoginSuccessView: View {
    let authToken: String?
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text("Login successful!")
                    .foregroundColor(.green)
                    .fontWeight(.medium)
            }
            
            if let token = authToken {
                TokenDisplayView(token: token)
            }

        }
        .padding()
        .background(Color.green.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .transition(.opacity.combined(with: .scale))
    }
}

// MARK: - Token Display Component
struct TokenDisplayView: View {
    let token: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Token received:")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            
            Text(String(token.prefix(20)) + "...")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.8))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }
}

// MARK: - Demo Credentials Component
struct DemoCredentialsView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Demo Credentials:")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
            
            VStack(spacing: 4) {
                Text("Username: mor_2314")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("Password: 83r5^_")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }
}
