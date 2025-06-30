//
//  CartItemRow.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/20/25.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct CartItemRow: View {
    let product: Product
    @Bindable var store: StoreOf<StoreFeature>
    
    var body: some View {
        let quantity = store.cart.quantity(for: product.id)
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
                    .frame(width: 60, height: 60)
                KFImage(URL(string: product.image)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 56, height: 56)
                    .clipped()
            }
            
            // Product details
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                Text("$\(String(format: "%.2f", product.price))")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            Spacer()
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Button(action: {
                        store.send(.removeFromCart(productId: product.id))
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.red)
                    }
                    .disabled(quantity <= 1)
                    .opacity(quantity <= 1 ? 0.5 : 1.0)
                    
                    Text("\(quantity)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(minWidth: 30)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: quantity)
                    
                    Button(action: {
                        store.send(.addToCart(productId: product.id))
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                }
                
                Text("$\(String(format: "%.2f", product.price * Double(quantity)))")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.35), radius: 4, x: 0, y: 2)
    }
}
