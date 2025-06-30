//
//  ApiDependency.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/23/25.
//

import Foundation
import ComposableArchitecture

protocol APIServiceProtocol {
    func getProducts() async throws -> [Product]
    func authUser(username: String, password: String) async throws -> AuthResponse
}

final class ApiDependency: APIServiceProtocol {
    private let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getProducts() async throws -> [Product] {
        let request = RequestBuilder
            .get("/products")
            .build()
        
        return try await networkManager.request(request)
    }

    func authUser(username: String, password: String) async throws -> AuthResponse {
        let loginRequest = LoginRequest(username: username, password: password)
        
        let request = try RequestBuilder
            .post("/auth/login")
            .header("Content-Type", value: "application/json")
            .body(loginRequest)
            .build()
        
        return try await networkManager.request(request)
    }
}

// MARK: - TCA Dependency
private enum APIServiceKey: DependencyKey {
    static let liveValue: APIServiceProtocol = ApiDependency()
}

extension DependencyValues {
    var apiService: APIServiceProtocol {
        get { self[APIServiceKey.self] }
        set { self[APIServiceKey.self] = newValue }
    }
}
