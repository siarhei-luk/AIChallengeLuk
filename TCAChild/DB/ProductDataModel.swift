//
//  ProductDataModel.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/27/25.
//

import Foundation
import SwiftData

@Model
final class ProductDataModel {
    @Attribute(.unique) var id: Int
    var title: String
    var price: Double
    var category: String
    var image: String
    var productDescription: String
    var dateAdded: Date
    
    init(
        id: Int,
        title: String,
        price: Double,
        category: String,
        image: String,
        description: String,
        dateAdded: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.price = price
        self.category = category
        self.image = image
        self.productDescription = description
        self.dateAdded = dateAdded
    }
}

// MARK: - Conversion Extensions
extension ProductDataModel {
    /// Convert SwiftData model to API Product struct
    func toProduct() -> Product {
        Product(
            id: id,
            title: title,
            price: price,
            category: category,
            image: image,
            description: productDescription
        )
    }
}

extension Product {
    /// Convert API Product struct to SwiftData model
    func toDataModel() -> ProductDataModel {
        ProductDataModel(
            id: id,
            title: title,
            price: price,
            category: category,
            image: image,
            description: description
        )
    }
}
