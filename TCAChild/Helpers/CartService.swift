//
//  CartService.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/23/25.
//

import Foundation
import ComposableArchitecture

protocol CartServiceProtocol {
    func addItem(to cartItems: Cart, productId: Int) -> Cart
    func removeItem(from cartItems: Cart, productId: Int) -> Cart
    func clearCart() -> Cart
}

// MARK: - Concrete Implementation
@Observable
final class CartService: CartServiceProtocol {

    func addItem(to cart: Cart, productId: Int) -> Cart {
        var updatedCart = cart
        updatedCart.items[productId] = (updatedCart.items[productId] ?? 0) + 1
        return updatedCart
    }

    func removeItem(from cart: Cart, productId: Int) -> Cart {
        var updatedCart = cart
        if let currentQuantity = updatedCart.items[productId], currentQuantity > 0 {
            if currentQuantity == 1 {
                updatedCart.items.removeValue(forKey: productId)
            } else {
                updatedCart.items[productId] = currentQuantity - 1
            }
        }
        return updatedCart
    }

    func clearCart() -> Cart {
        Cart()
    }
}

// MARK: - TCA Dependency
private enum CartServiceKey: DependencyKey {
    static let liveValue: CartServiceProtocol = CartService()
    static let testValue: CartServiceProtocol = CartService()
}

extension DependencyValues {
    var cartService: CartServiceProtocol {
        get { self[CartServiceKey.self] }
        set { self[CartServiceKey.self] = newValue }
    }
}

