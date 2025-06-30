//
//  ProductCard.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/20/25.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct ProductCard: View {
    let product: Product
    @Bindable var store: StoreOf<StoreFeature>
    
    @State private var isPressed = false
    
    var body: some View {
        let quantity = store.cart.quantity(for: product.id)

        NavigationLink(destination: ProductDetailView(store: store, product: product)) {
            VStack(alignment: .leading, spacing: 8) {
                // Product image
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .frame(height: 140)
                    KFImage(URL(string: product.image))
                        .resizable()
                        .serialize(as: .PNG)
                        .frame(height: 140)
                }
                
                // Product info
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.title)
                        .font(.headline)
                        .fontWeight(.medium)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text("$\(String(format: "%.2f", product.price))")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                
                cartButton(quantity: quantity)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private func cartButton(quantity: Int) -> some View {
        if quantity == 0 {
            Button(action: {
                store.send(.addToCart(productId: product.id))
            }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.caption)
                    
                    Text("Add to Cart")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.blue)
                .cornerRadius(8)
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        } else {
            quantityControls(quantity: quantity)
        }
    }
    
    @ViewBuilder
    private func quantityControls(quantity: Int) -> some View {
        HStack(spacing: 0) {
            Button(action: {
                store.send(.removeFromCart(productId: product.id))
            }) {
                Image(systemName: "minus")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(PlainButtonStyle())
            
            Text("\(quantity)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background(Color(.systemGray6))
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: quantity)
            
            Button(action: {
                store.send(.addToCart(productId: product.id))
            }) {
                Image(systemName: "plus")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .transition(.scale.combined(with: .opacity))
    }
}
