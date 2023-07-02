//
//  RootViewModel.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import AuthenticationServices
import Foundation

protocol RootViewModelOutput: AnyObject {
	func showLoginPage()
	func showMainPage()
}

final class RootViewModel {
	private let appleIDProvider = ASAuthorizationAppleIDProvider()
	weak var output: RootViewModelOutput?

	func checkAuth() {
		appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { state, _ in
			switch state {
			case .authorized:
				DispatchQueue.main.async {
					self.output?.showMainPage()
				}
			case .revoked, .notFound:
				DispatchQueue.main.async {
					self.output?.showLoginPage()
				}
			default:
				break
			}
		}
	}
}
