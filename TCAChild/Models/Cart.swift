//
//  Cart.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/25/25.
//

import Foundation

struct Cart {
    var items: [Int: Int] = [:]

    var totalItems: Int {
        items.values.reduce(0, +)
    }

    var isEmpty: Bool {
        items.isEmpty
    }

    func quantity(for productId: Int) -> Int {
        items[productId] ?? 0
    }
}
