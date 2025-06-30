//
//  CartView.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/19/25.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct CartView: View {
    @Bindable var store: StoreOf<StoreFeature>

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            if store.showOrderSuccess {
                orderSuccessView
            } else {
                cartContentView
            }
        }
        .navigationTitle("Shopping Cart")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var cartContentView: some View {
        VStack(spacing: 0) {
            if store.cart.isEmpty {
                emptyCartView
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(store.cartProducts, id: \.product.id) { item in
                            CartItemRow(
                                product: item.product,
                                store: store
                            )
                        }
                    }
                    .padding()
                }
                summarySection
                completeButton
            }
        }
    }
    
    private var orderSuccessView: some View {
        VStack(spacing: 30) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.green)
            }
            .scaleEffect(store.showOrderSuccess ? 1.0 : 0.5)
            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: store.showOrderSuccess)

            VStack(spacing: 16) {
                Text("Order Completed!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text("Thank you for your purchase.\nYour order has been successfully placed.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)

                VStack(spacing: 8) {
                    HStack {
                        Text("Order Total:")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("$\(String(format: "%.2f", store.totalPrice))")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
            }
            
            Spacer()

            VStack(spacing: 12) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        store.send(.clearCart)
                        dismiss()
                    }
                }) {
                    Text("Continue Shopping")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
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
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
    
    private var emptyCartView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "cart")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            
            Text("Your cart is empty")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Text("Add some products to get started")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
    }
    
    private var summarySection: some View {
        VStack(spacing: 12) {
            Divider()

            HStack {
                Text("Total Items:")
                    .font(.body)
                    .foregroundColor(.primary)

                Spacer()

                Text("\(store.cart.totalItems)")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }

            HStack {
                Text("Total Price:")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Spacer()

                Text("$\(String(format: "%.2f", store.totalPrice))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    private var completeButton: some View {
        Button(action: {
            store.send(.completeOrder)
        }) {
            Text("Complete Order")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
        }
        .padding()
        .background(Color(.systemBackground))
        .disabled(store.cart.isEmpty)
        .opacity(store.cart.isEmpty ? 0.6 : 1.0)
    }
}
