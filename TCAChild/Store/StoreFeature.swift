//
//  StoreFeature.swift
//  TCAChild
//
//

import Foundation
import ComposableArchitecture

@Reducer
struct StoreFeature {
    @ObservableState
    struct State {
        var searchText: String = ""
        var selectedCategory: String = "All"
        var products = [Product]()
        var isLoading: Bool = false
        var cart = Cart()
        var showOrderSuccess: Bool = false
        var isConnected = true
        var showConnectivityBanner = false
        var favoriteProducts = [Product]()
        var showFavoritesOnly = false

        var uniqueCategories: [String] {
            let categories = Array(Set(products.map { $0.category.capitalized })).sorted()
            return ["All"] + categories
        }

        var filteredProducts: [Product] {
            let baseProducts = showFavoritesOnly ? favoriteProducts : products
            let categoryFiltered = selectedCategory == "All" ? baseProducts : baseProducts.filter { $0.category.capitalized == selectedCategory }
            
            if searchText.isEmpty {
                return categoryFiltered
            } else {
                return categoryFiltered.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            }
        }

        var cartProducts: [(product: Product, quantity: Int)] {
            cart.items.compactMap { (productId, quantity) in
                if let product = products.first(where: { $0.id == productId }) {
                    return (product: product, quantity: quantity)
                }
                return nil
            }.sorted { $0.product.title < $1.product.title }
        }

        var totalPrice: Double {
            cartProducts.reduce(0) { total, item in
                total + (item.product.price * Double(item.quantity))
            }
        }
    }

    enum Action {
        case onAppear
        case selectCategory(category: String)
        case addToCart(productId: Int)
        case removeFromCart(productId: Int)
        case listOfProductsReceived([Product])
        case textChanged(String)
        case completeOrder
        case clearCart
        case networkStatusChanged(Bool)
        case startNetworkMonitoring
        case dismissConnectivityBanner
        // SwiftData actions
        case loadProductsFromCache
        case cacheProductsReceived([Product])
    }

    @Dependency(\.cartService) var cartService
    @Dependency(\.apiService) var apiService
    @Dependency(\.networkMonitor) var networkMonitor
    @Dependency(\.productDataService) var productDataService
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .selectCategory(category):
                state.selectedCategory = category
                return .none
                
            case let .addToCart(productId):
                state.cart = cartService.addItem(to: state.cart, productId: productId)
                return .none
                
            case let .removeFromCart(productId):
                state.cart = cartService.removeItem(from: state.cart, productId: productId)
                return .none
                
            case .onAppear:
                state.isLoading = true
                // First load from cache, then try to fetch from API
                return .run { send in
                    await send(.loadProductsFromCache)
                    
                    // Try to fetch from API if connected
                    do {
                        try await Task.sleep(for: .seconds(2))
                        let products = try await apiService.getProducts()
                        await send(.listOfProductsReceived(products))
                    } catch {
                        // If API fails, we already have cached data
                        debugPrint("Failed to fetch from API: \(error)")
                    }
                }
                
            case .loadProductsFromCache:
                return .run { send in
                    do {
                        try await Task.sleep(for: .seconds(2))
                        let cachedProducts = try await productDataService.getProducts()
                        await send(.cacheProductsReceived(cachedProducts))
                    } catch {
                        debugPrint("Failed to load cached products: \(error)")
                    }
                }
                
            case let .cacheProductsReceived(products):
                if state.products.isEmpty {
                    state.products = products
                    state.isLoading = false
                }
                return .none
                
            case let .listOfProductsReceived(products):
                state.isLoading = false
                state.products = products
                
                // Cache the products
                return .run { _ in
                    do {
                        try await productDataService.saveProducts(products)
                    } catch {
                        debugPrint("Failed to cache products: \(error)")
                    }
                }
                
            case let .textChanged(text):
                state.searchText = text
                return .none
                
            case .completeOrder:
                guard state.isConnected else {
                    return .none
                }
                state.showOrderSuccess = true
                return .run { send in
                    try await Task.sleep(for: .seconds(2))
                    await send(.clearCart)
                }
                
            case .clearCart:
                state.showOrderSuccess = false
                state.cart = cartService.clearCart()
                return .none
                
            case .startNetworkMonitoring:
                return .run { send in
                    for await isConnected in await networkMonitor.startMonitoring() {
                        await send(.networkStatusChanged(isConnected))
                    }
                }
                
            case let .networkStatusChanged(isConnected):
                let wasDisconnected = !state.isConnected
                state.isConnected = isConnected
                
                if !isConnected {
                    state.showConnectivityBanner = true
                    if state.isLoading {
                        state.isLoading = false
                    }
                } else if wasDisconnected && isConnected {
                    state.showConnectivityBanner = false
                    if state.products.isEmpty {
                        return .run { send in
                            await send(.onAppear)
                        }
                    }
                }
                return .none
                
            case .dismissConnectivityBanner:
                state.showConnectivityBanner = false
                return .none
            }
        }
    }
}
