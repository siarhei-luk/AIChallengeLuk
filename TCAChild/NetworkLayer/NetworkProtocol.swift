//
//  NetworkManager.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/19/25.
//

import Foundation

protocol NetworkProtocol {
    func request<T: Codable>(_ request: NetworkRequest) async throws -> T
    func request(_ request: NetworkRequest) async throws -> Data
}

// MARK: - HTTP Method
enum HTTPMethod: String, CaseIterable {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

// MARK: - Network Request Configuration
struct NetworkRequest {
    let endpoint: String
    let method: HTTPMethod
    let headers: [String: String]?
    let parameters: [String: Any]?
    let body: Data?
    
    init(
        endpoint: String,
        method: HTTPMethod = .GET,
        headers: [String: String]? = nil,
        parameters: [String: Any]? = nil,
        body: Data? = nil
    ) {
        self.endpoint = endpoint
        self.method = method
        self.headers = headers
        self.parameters = parameters
        self.body = body
    }
}

// MARK: - Network Errors
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case encodingError(Error)
    case serverError(Int, Data?)
    case networkError(Error)
    case unauthorized
    case forbidden
    case notFound
    case timeout
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Encoding error: \(error.localizedDescription)"
        case .serverError(let code, _):
            return "Server error with code: \(code)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized access"
        case .forbidden:
            return "Forbidden access"
        case .notFound:
            return "Resource not found"
        case .timeout:
            return "Request timeout"
        }
    }
}

