//
//  Auth.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/26/25.
//

import Foundation

// MARK: - Auth Models
struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct AuthResponse: Codable, Equatable {
    let token: String
}
