//
//  SubscriptionViewModel.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 3.07.2023.
//

import Combine
import Foundation
import StoreKit

final class SubscriptionViewModel {
	enum Input {
		case viewDidLoad
		case didBuyTapped(product: Product)
		case didRestoreTapped
	}
	
	enum Output {
		case subscriptionsFetched
		case currentSubscriptionsFetched
		case purchaseSuccessfull
		case errorOccured(error: Swift.Error)
	}
	
	@Published var items: [Product] = []
	@Published var currentSubscription: Product?
	@Published var status: Product.SubscriptionInfo.Status?
	private let storeManager: StoreKitManager = .init()
	private let output = PassthroughSubject<Output, Never>()
	private var cancellables = Set<AnyCancellable>()
	
	func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
		input.sink { [unowned self] event in
			switch event {
			case .viewDidLoad:
				self.fetchSubsriptions()
				self.getCurrentSubscription()
			case .didBuyTapped(product: let product):
				Task {
					await self.buy(product: product)
				}
			case .didRestoreTapped:
				self.restorePurchase()
			}
		}.store(in: &cancellables)
		
		return output.eraseToAnyPublisher()
	}
	
	func fetchSubsriptions() {
		Task {
			await storeManager.requestProducts()
			self.items = storeManager.subscriptions
			self.getCurrentSubscription()
			output.send(.subscriptionsFetched)
		}
	}
	
	func buy(product: Product) async {
		do {
			if try await storeManager.purchase(product) != nil {
				output.send(.purchaseSuccessfull)
			}
		} catch {
			output.send(.errorOccured(error: error))
		}
	}
	
	func restorePurchase() {
		Task {
			try? await AppStore.sync()
			fetchSubsriptions()
			getCurrentSubscription()
		}
	}
	
	func getCurrentSubscription() {
		Task {
			await updateSubscriptionStatus()
		}
	}
	
	func checkIsPurchased(product: Product) async -> Bool? {
		return try? await storeManager.isPurchased(product)
	}
}

extension SubscriptionViewModel {
	@MainActor
	func updateSubscriptionStatus() async {
		do {
			guard let product = storeManager.subscriptions.first,
			      let statuses = try await product.subscription?.status else { return }
			
			var highestStatus: Product.SubscriptionInfo.Status?
			var highestProduct: Product?
			
			for status in statuses {
				switch status.state {
				case .expired, .revoked:
					continue
				default:
					let renewalInfo = try storeManager.checkVerified(status.renewalInfo)
					
					// Find the first subscription product that matches the subscription status renewal info by comparing the product IDs.
					guard let newSubscription = storeManager.subscriptions.first(where: { $0.id == renewalInfo.currentProductID }) else {
						continue
					}
					
					guard let currentProduct = highestProduct else {
						highestStatus = status
						highestProduct = newSubscription
						continue
					}
					
					let highestTier = storeManager.tier(for: currentProduct.id)
					let newTier = storeManager.tier(for: renewalInfo.currentProductID)
					
					if newTier > highestTier {
						highestStatus = status
						highestProduct = newSubscription
					}
				}
			}
			
			status = highestStatus
			currentSubscription = highestProduct
			output.send(.currentSubscriptionsFetched)
		} catch {
			CrashlyticsManager.shared.sendNonFatal(error: error)
			output.send(.errorOccured(error: error))
		}
	}
}
