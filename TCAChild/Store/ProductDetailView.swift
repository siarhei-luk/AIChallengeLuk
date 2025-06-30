//
//  ProductDetailView.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/19/25.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct ProductDetailView: View {
    @Bindable var store: StoreOf<StoreFeature>
    let product: Product
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        let quantity = store.cart.quantity(for: product.id)
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Product Image
                productImageSection
                
                // Product Information
                productInfoSection
                
                // Description Section
                descriptionSection
                
                // Add to Cart Section
                addToCartSection(quantity: quantity)
                
                Spacer(minLength: 100) // Space for floating button
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                cartButton
            }
        }
    }
    
    private var productImageSection: some View {
        HStack(alignment: .center) {
            KFImage(URL(string: product.image))
                .resizable()
                .frame(width: 150, height: 150)
        }
    }
    
    private var productInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title
            Text(product.title)
                .font(.title2)
                .fontWeight(.bold)
                .lineLimit(nil)
            
            // Category
            HStack {
                Text(product.category.capitalized)
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(12)
                
                Spacer()
            }
            
            // Price
            HStack {
                Text("$\(String(format: "%.2f", product.price))")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Spacer()
            }
        }
        .padding(.vertical)
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Description")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(product.description)
                .font(.body)
                .lineSpacing(4)
                .foregroundColor(.secondary)
        }
        .padding(.vertical)
    }
    
    @ViewBuilder
    private func addToCartSection(quantity: Int) -> some View {
        VStack(spacing: 16) {
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Quantity")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    if quantity > 0 {
                        Text("\(quantity) in cart")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                quantityControls(quantity: quantity)
            }
            
            // Add to Cart / Update Cart Button
            cartActionButton(quantity: quantity)
        }
        .padding(.vertical)
    }
    
    @ViewBuilder
    private func quantityControls(quantity: Int) -> some View {
        HStack(spacing: 12) {
            if quantity > 0 {
                Button(action: {
                    store.send(.removeFromCart(productId: product.id))
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                }
                
                Text("\(quantity)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(minWidth: 30)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: quantity)
            }
            
            Button(action: {
                store.send(.addToCart(productId: product.id))
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
    }
    
    @ViewBuilder
    private func cartActionButton(quantity: Int) -> some View {
        Button(action: {
            store.send(.addToCart(productId: product.id))
        }) {
            HStack {
                Image(systemName: quantity > 0 ? "cart.badge.plus" : "cart.badge.plus")
                    .font(.headline)
                
                Text(quantity > 0 ? "Add More to Cart" : "Add to Cart")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
        }
    }
    
    private var cartButton: some View {
        NavigationLink(
            destination: CartView(
                store: store
            )
        ) {
            ZStack {
                Image(systemName: "bag")
                    .font(.title3)
                    .foregroundColor(.primary)
                
                if store.cart.totalItems > 0 {
                    Text("\(store.cart.totalItems)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 16, height: 16)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 8, y: -8)
                }
            }
        }
    }
}
