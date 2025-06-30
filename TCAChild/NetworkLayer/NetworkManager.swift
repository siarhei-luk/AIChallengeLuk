//
//  NetworkManager.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/19/25.
//

import Foundation

final class NetworkManager: NetworkProtocol {
    
    // MARK: - Properties
    private let configuration: NetworkConfiguration
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    // MARK: - Initialization
    init(
        configuration: NetworkConfiguration = .default,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.configuration = configuration
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
        
        // Configure session
        session.configuration.timeoutIntervalForRequest = configuration.timeoutInterval
    }
    
    // MARK: - Public Methods
    func request<T: Codable>(_ request: NetworkRequest) async throws -> T {
        let data = try await performRequest(request)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    func request(_ request: NetworkRequest) async throws -> Data {
        return try await performRequest(request)
    }
    
    // MARK: - Private Methods
    private func performRequest(_ request: NetworkRequest) async throws -> Data {
        let urlRequest = try buildURLRequest(from: request)
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            try validateResponse(response, data: data)
            return data
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    private func buildURLRequest(from request: NetworkRequest) throws -> URLRequest {
        guard let url = buildURL(endpoint: request.endpoint, parameters: request.parameters) else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        // Add default headers
        configuration.defaultHeaders.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add custom headers
        request.headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add body for non-GET requests
        if let body = request.body {
            urlRequest.httpBody = body
        }
        
        return urlRequest
    }
    
    private func buildURL(endpoint: String, parameters: [String: Any]?) -> URL? {
        guard let baseURL = URL(string: configuration.baseURL) else { return nil }
        guard let url = URL(string: endpoint, relativeTo: baseURL) else { return nil }
        
        guard let parameters = parameters, !parameters.isEmpty else {
            return url
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        
        return components?.url
    }
    
    private func validateResponse(_ response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.networkError(NSError(domain: "Invalid response", code: 0))
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 408:
            throw NetworkError.timeout
        default:
            throw NetworkError.serverError(httpResponse.statusCode, data)
        }
    }
}

