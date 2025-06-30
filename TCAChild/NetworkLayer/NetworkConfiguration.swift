//
//  NetworkConfiguration.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/19/25.
//

import Foundation

struct NetworkConfiguration {
    let baseURL: String
    let defaultHeaders: [String: String]
    let timeoutInterval: TimeInterval
    
    init(
        baseURL: String,
        defaultHeaders: [String: String] = [:],
        timeoutInterval: TimeInterval = 30.0
    ) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
        self.timeoutInterval = timeoutInterval
    }

    static let `default` = NetworkConfiguration(
        baseURL: "https://fakestoreapi.com",
        defaultHeaders: [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    )
}
