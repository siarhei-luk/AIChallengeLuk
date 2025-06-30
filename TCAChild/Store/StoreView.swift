//
//  StoreView.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/19/25.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct StoreView: View {
    @Bindable var store: StoreOf<StoreFeature>

    var body: some View {
        NavigationView {
            VStack {
                // Connectivity banner
                if store.showConnectivityBanner {
                    ConnectivityBanner(
                        isConnected: store.isConnected) {
                            store.send(.dismissConnectivityBanner)
                        }
                }
                
                // Main content with loading state
                ZStack {
                    if store.isLoading {
                        SkeletonView()
                    } else {
                        mainContentView
                    }
                }
                .background(Color(.systemBackground))
            }
            .navigationTitle("Store")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            store.send(.startNetworkMonitoring)
            if store.cart.isEmpty {
                store.send(.onAppear)
            }
        }
    }

    private var mainContentView: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerView
                
                categorySelector
                
                productsGrid
            }
            .padding(.horizontal)
        }
    }
    
    private var headerView: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search products...", text: $store.searchText.sending(\.textChanged))
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            NavigationLink(destination: CartView(
                store: store
            )) {
                ZStack {
                    Image(systemName: "bag")
                        .font(.title2)
                        .foregroundColor(.primary)
                    
                    if store.cart.totalItems > 0 {
                        Text("\(store.cart.totalItems)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 18, height: 18)
                            .background(Color.red)
                            .clipShape(Circle())
                            .offset(x: 10, y: -10)
                    }
                }
            }
            .padding(.leading, 8)
        }
    }
    
    private var categorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(store.uniqueCategories, id: \.self) { category in
                    Button(action: {
                        store.send(.selectCategory(category: category))
                    }) {
                        Text(category)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                store.selectedCategory == category ?
                                Color.blue : Color(.systemGray6)
                            )
                            .foregroundColor(
                                store.selectedCategory == category ?
                                .white : .primary
                            )
                            .cornerRadius(20)
                    }
                    .disabled(!store.isConnected) // Disable category selection when offline
                }
            }
            .padding(.horizontal)
        }
        .opacity(store.isConnected ? 1.0 : 0.6) // Visual feedback for offline state
    }
    
    private var productsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 16) {
            ForEach(store.filteredProducts) { product in
                ProductCard(
                    product: product,
                    store: store
                )
                .opacity(store.isConnected ? 1.0 : 0.6) // Visual feedback for offline state
            }
        }
    }
}
