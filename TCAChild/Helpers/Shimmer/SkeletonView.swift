//
//  SkeletonView.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/20/25.
//

import SwiftUI

struct SkeletonView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSkeletonView
                categorySkeletonView
                productsGridSkeleton
            }
            .padding(.horizontal)
        }
    }
    
    private var headerSkeletonView: some View {
        HStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .frame(height: 44)
                .shimmer()
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray6))
                .frame(width: 44, height: 44)
                .shimmer()
        }
    }

    private var categorySkeletonView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<5, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemGray6))
                        .frame(width: 80, height: 32)
                        .shimmer()
                        .animation(.easeInOut.delay(Double(index) * 0.1), value: true)
                }
            }
            .padding(.horizontal)
        }
    }

    private var productsGridSkeleton: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 16) {
            ForEach(0..<6, id: \.self) { index in
                VStack(alignment: .leading, spacing: 8) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .frame(height: 140)
                        .shimmer()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray6))
                            .frame(height: 20)
                            .shimmer()
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray6))
                            .frame(height: 16)
                            .frame(width: 80)
                            .shimmer()
                    }
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                        .frame(height: 36)
                        .shimmer()
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                .animation(.easeInOut.delay(Double(index) * 0.05), value: true)
            }
        }
    }
}

