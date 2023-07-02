//
//  LoginViewModel.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 2.07.2023.
//

import AuthenticationServices
import Combine
import Foundation

final class LoginViewModel: ObservableObject {
	enum Input {
		case signInWithAppleButtonDidTapped
		case saveUserToKeychain(_ userIdentifier: String, _ fullName: String, _ email: String)
	}

	enum Output {
		case successfullySignedInWithApple
		case errorOccured(error: Swift.Error)
	}

	private let output = PassthroughSubject<Output, Never>()
	private var cancellables = Set<AnyCancellable>()

	func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
		input.sink { [weak self] event in
			switch event {
			case .signInWithAppleButtonDidTapped:
				self?.signInWithApple()
			case .saveUserToKeychain(let uid, let fullName, let email):
				self?.saveUserToKeychain(uid, fullName, email)
			}
		}.store(in: &cancellables)

		return output.eraseToAnyPublisher()
	}

	func signInWithApple() {
		output.send(.successfullySignedInWithApple)
	}

	func saveUserToKeychain(_ userIdentifier: String, _ fullName: String, _ email: String) {
		do {
			try KeychainItem(service: bundleID, account: KeychainItem.StorageKeys.userIdentifier.rawValue).saveItem(userIdentifier)
			try KeychainItem(service: bundleID, account: KeychainItem.StorageKeys.fullName.rawValue).saveItem(fullName)
			try KeychainItem(service: bundleID, account: KeychainItem.StorageKeys.email.rawValue).saveItem(email)
		} catch {
			print("Unable to save userIdentifier to keychain.")
		}
	}
}
