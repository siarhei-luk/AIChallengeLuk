//
//  ProductDataService.swift
//  TCAChild
//
//  Created by Sergey Luk on 6/27/25.
//

import Foundation
import SwiftData
import ComposableArchitecture

protocol ProductDataServiceProtocol {
    func saveProducts(_ products: [Product]) async throws
    func getProducts() async throws -> [Product]
    func getProduct(by id: Int) async throws -> Product?
    func deleteProduct(by id: Int) async throws
    func clearAllProducts() async throws
}

// MARK: - Concrete Implementation
@Observable
final class ProductDataService: ProductDataServiceProtocol {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    init() throws {
        // Configure model container
        let schema = Schema([ProductDataModel.self])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            modelContext = ModelContext(modelContainer)
        } catch {
            throw DataServiceError.initializationFailed(error)
        }
    }
    
    // MARK: - CRUD Operations
    
    func saveProducts(_ products: [Product]) async throws {
        try await MainActor.run {
            for product in products {
                // Check if product already exists
                let predicate = #Predicate<ProductDataModel> { $0.id == product.id }
                let descriptor = FetchDescriptor<ProductDataModel>(predicate: predicate)
                
                let existingProducts = try modelContext.fetch(descriptor)
                
                if existingProducts.isEmpty {
                    // Insert new product
                    let dataModel = product.toDataModel()
                    modelContext.insert(dataModel)
                } else {
                    // Update existing product (except favorite status)
                    let existingProduct = existingProducts.first!
                    existingProduct.title = product.title
                    existingProduct.price = product.price
                    existingProduct.category = product.category
                    existingProduct.image = product.image
                    existingProduct.productDescription = product.description
                }
            }
            
            try modelContext.save()
        }
    }
    
    func getProducts() async throws -> [Product] {
        try await MainActor.run {
            let descriptor = FetchDescriptor<ProductDataModel>(
                sortBy: [SortDescriptor(\.dateAdded, order: .forward)]
            )
            let dataModels = try modelContext.fetch(descriptor)
            return dataModels.map { $0.toProduct() }
        }
    }
    
    func getProduct(by id: Int) async throws -> Product? {
        try await MainActor.run {
            let predicate = #Predicate<ProductDataModel> { $0.id == id }
            let descriptor = FetchDescriptor<ProductDataModel>(predicate: predicate)
            let dataModels = try modelContext.fetch(descriptor)
            return dataModels.first?.toProduct()
        }
    }
    
    func deleteProduct(by id: Int) async throws {
        try await MainActor.run {
            let predicate = #Predicate<ProductDataModel> { $0.id == id }
            let descriptor = FetchDescriptor<ProductDataModel>(predicate: predicate)
            let dataModels = try modelContext.fetch(descriptor)
            
            for dataModel in dataModels {
                modelContext.delete(dataModel)
            }
            
            try modelContext.save()
        }
    }
    
    func clearAllProducts() async throws {
        try await MainActor.run {
            let descriptor = FetchDescriptor<ProductDataModel>()
            let dataModels = try modelContext.fetch(descriptor)
            
            for dataModel in dataModels {
                modelContext.delete(dataModel)
            }
            
            try modelContext.save()
        }
    }
}

// MARK: - Error Handling
enum DataServiceError: Error {
    case initializationFailed(Error)
    case productNotFound
    case saveFailed(Error)
    case fetchFailed(Error)
    case deleteFailed(Error)
}

extension DataServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .initializationFailed(let error):
            return "Failed to initialize data service: \(error.localizedDescription)"
        case .productNotFound:
            return "Product not found"
        case .saveFailed(let error):
            return "Failed to save: \(error.localizedDescription)"
        case .fetchFailed(let error):
            return "Failed to fetch: \(error.localizedDescription)"
        case .deleteFailed(let error):
            return "Failed to delete: \(error.localizedDescription)"
        }
    }
}

// MARK: - TCA Dependency
private enum ProductDataServiceKey: DependencyKey {
    static let liveValue: ProductDataServiceProtocol = {
        do {
            return try ProductDataService()
        } catch {
            fatalError("Failed to create ProductDataService: \(error)")
        }
    }()
    
}

extension DependencyValues {
    var productDataService: ProductDataServiceProtocol {
        get { self[ProductDataServiceKey.self] }
        set { self[ProductDataServiceKey.self] = newValue }
    }
}
