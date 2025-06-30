//
//  NetworkMonitor.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/26/25.
//

import Network
import ComposableArchitecture
import Combine

// MARK: - Network Monitor Dependency
struct NetworkMonitor {
    var startMonitoring: @Sendable () async -> AsyncStream<Bool>
    var stopMonitoring: @Sendable () async -> Void
}

extension NetworkMonitor: DependencyKey {
    static let liveValue = NetworkMonitor(
        startMonitoring: {
            AsyncStream { continuation in
                let monitor = NWPathMonitor()
                let queue = DispatchQueue(label: "NetworkMonitor")
                
                monitor.pathUpdateHandler = { path in
                    let isConnected = path.status == .satisfied
                    continuation.yield(isConnected)
                }
                
                monitor.start(queue: queue)
                
                continuation.onTermination = { _ in
                    monitor.cancel()
                }
            }
        },
        stopMonitoring: {
            // Implementation handled by AsyncStream termination
        }
    )
    
    static let testValue = NetworkMonitor(
        startMonitoring: {
            AsyncStream { continuation in
                // For testing - simulate connected state
                continuation.yield(true)
            }
        },
        stopMonitoring: {}
    )
}

extension DependencyValues {
    var networkMonitor: NetworkMonitor {
        get { self[NetworkMonitor.self] }
        set { self[NetworkMonitor.self] = newValue }
    }
}

