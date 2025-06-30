//
//  ConnectivityBanner.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/26/25.
//

import SwiftUI

struct ConnectivityBanner: View {
    let isConnected: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: isConnected ? "wifi" : "wifi.slash")
                .foregroundColor(isConnected ? .green : .white)
                .font(.system(size: 16, weight: .medium))
            
            Text(isConnected ? "Connected" : "No Internet Connection")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
            
            Spacer()
            
            if !isConnected {
                Button("Dismiss") {
                    onDismiss()
                }
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(isConnected ? Color.green : Color.red)
                .shadow(radius: 4)
        )
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

