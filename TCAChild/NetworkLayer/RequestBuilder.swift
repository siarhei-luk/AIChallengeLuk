//
//  RequestBuilder.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/19/25.
//

import Foundation

final class RequestBuilder {
    private var endpoint: String = ""
    private var method: HTTPMethod = .GET
    private var headers: [String: String] = [:]
    private var parameters: [String: Any] = [:]
    private var body: Data?
    
    // MARK: - Builder Methods
    func endpoint(_ endpoint: String) -> RequestBuilder {
        self.endpoint = endpoint
        return self
    }
    
    func method(_ method: HTTPMethod) -> RequestBuilder {
        self.method = method
        return self
    }
    
    func header(_ key: String, value: String) -> RequestBuilder {
        self.headers[key] = value
        return self
    }
    
    func headers(_ headers: [String: String]) -> RequestBuilder {
        headers.forEach { self.headers[$0.key] = $0.value }
        return self
    }
    
    func parameter(_ key: String, value: Any) -> RequestBuilder {
        self.parameters[key] = value
        return self
    }
    
    func parameters(_ parameters: [String: Any]) -> RequestBuilder {
        parameters.forEach { self.parameters[$0.key] = $0.value }
        return self
    }
    
    func body<T: Codable>(_ object: T, encoder: JSONEncoder = JSONEncoder()) throws -> RequestBuilder {
        self.body = try encoder.encode(object)
        return self
    }
    
    func body(_ data: Data) -> RequestBuilder {
        self.body = data
        return self
    }
    
    // MARK: - Build Method
    func build() -> NetworkRequest {
        return NetworkRequest(
            endpoint: endpoint,
            method: method,
            headers: headers.isEmpty ? nil : headers,
            parameters: parameters.isEmpty ? nil : parameters,
            body: body
        )
    }
    
    // MARK: - Static Factory Methods
    static func get(_ endpoint: String) -> RequestBuilder {
        return RequestBuilder().endpoint(endpoint).method(.GET)
    }
    
    static func post(_ endpoint: String) -> RequestBuilder {
        return RequestBuilder().endpoint(endpoint).method(.POST)
    }
    
    static func put(_ endpoint: String) -> RequestBuilder {
        return RequestBuilder().endpoint(endpoint).method(.PUT)
    }
    
    static func delete(_ endpoint: String) -> RequestBuilder {
        return RequestBuilder().endpoint(endpoint).method(.DELETE)
    }
}

