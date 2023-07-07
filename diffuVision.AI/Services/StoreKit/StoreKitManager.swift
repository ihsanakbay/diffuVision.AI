//
//  StoreKitManager.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 3.07.2023.
//

import Foundation
import StoreKit

typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

public enum StoreError: Error {
	case failedVerification
}

final class StoreKitManager: ObservableObject {
	static let shared = StoreKitManager()

	@Published private(set) var subscriptions: [Product] = []
	@Published private(set) var purchasedSubscriptions: [Product] = []
	@Published private(set) var subscriptionGroupStatus: RenewalState?

	private let productIds: [String] = ["subscription.weekly", "subscription.monthly", "subscription.yearly"]
	var updateListenerTask: Task<Void, Error>? = nil

	init() {
		self.updateListenerTask = listenForTransactions()
		Task {
			await requestProducts()
			await updateCustomerProductStatus()
		}
	}

	deinit {
		self.updateListenerTask?.cancel()
	}

	func listenForTransactions() -> Task<Void, Error> {
		return Task.detached {
			for await result in Transaction.updates {
				do {
					let transaction = try self.checkVerified(result)
					await self.updateCustomerProductStatus()
					await transaction.finish()
				} catch {
					print("transaction failed verification")
				}
			}
		}
	}

	@MainActor
	func requestProducts() async {
		do {
			subscriptions = try await Product.products(for: productIds)
//			print(subscriptions)
		} catch {
			print("Failed product request from app store server: \(error)")
		}
	}

	func purchase(_ product: Product) async throws -> Transaction? {
		let result = try await product.purchase()

		switch result {
		case .success(let verification):
			let transaction = try checkVerified(verification)
			await updateCustomerProductStatus()
			await transaction.finish()
			return transaction

		case .userCancelled, .pending:
			return nil
		default:
			return nil
		}
	}

	func isPurchased(_ product: Product) async throws -> Bool {
		switch product.type {
		case .autoRenewable:
			return purchasedSubscriptions.contains(product)
		default:
			return false
		}
	}

	func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
		switch result {
		case .unverified:
			throw StoreError.failedVerification
		case .verified(let safe):
			return safe
		}
	}

	@MainActor
	func updateCustomerProductStatus() async {
		for await result in Transaction.currentEntitlements {
			do {
				let transaction = try checkVerified(result)
				switch transaction.productType {
				case .autoRenewable:
					if let subscription = subscriptions.first(where: { $0.id == transaction.productID }) {
						purchasedSubscriptions.append(subscription)
					}
				default:
					break
				}
				await transaction.finish()
			} catch {
				print("Failed updating products")
			}
		}
	}

	func tier(for productId: String) -> SubscriptionTier {
		switch productId {
		case "subscription.weekly":
			return .weekly
		case "subscription.monthly":
			return .monthly
		case "subscription.yearly":
			return .yearly
		default:
			return .none
		}
	}

	public enum SubscriptionTier: Int, Comparable {
		case none = 0
		case weekly = 1
		case monthly = 2
		case yearly = 3

		public static func < (lhs: Self, rhs: Self) -> Bool {
			return lhs.rawValue < rhs.rawValue
		}
	}
}
