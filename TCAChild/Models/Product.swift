//
//  Product.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/19/25.
//

import Foundation

struct Product: Identifiable {
    let id: Int
    let title: String
    let price: Double
    let category: String
    let image: String
    let description: String
}

extension Product: Codable {}
