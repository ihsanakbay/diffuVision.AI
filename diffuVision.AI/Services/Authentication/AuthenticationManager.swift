//
//  AuthenticationManager.swift
//  diffuVision
//
//  Created by İhsan Akbay on 17.06.2023.
//

import AuthenticationServices
import FirebaseAuth
import FirebaseFirestore
import Foundation

enum AuthProviderOption: String {
	case apple = "apple.com"
}

final class AuthenticationManager {
	static let shared = AuthenticationManager()
	private init() {}

	func getAuthenticatedUser() throws -> AuthDataResultModel {
		guard let user = Auth.auth().currentUser else {
			throw NetworkRequestError.notFound
		}

		return AuthDataResultModel(user: user)
	}

	func getProvider() throws -> [AuthProviderOption] {
		guard let providerData = Auth.auth().currentUser?.providerData else {
			throw NetworkRequestError.error5xx(500)
		}
		var providers: [AuthProviderOption] = []
		for provider in providerData {
			if let option = AuthProviderOption(rawValue: provider.providerID) {
				providers.append(option)
			} else {
				assertionFailure("Provider option not found: \(provider.providerID)")
			}
		}
		print(providers)
		return providers
	}

	func signOut() throws {
		try Auth.auth().signOut()
	}

	func delete() async throws {
		guard let user = Auth.auth().currentUser else { throw NetworkRequestError.badRequest }
		try await user.delete()
		try signOut()
	}
}

// MARK: SignIn methods

extension AuthenticationManager {
	func signIn(with credentials: AuthCredential) async throws -> AuthDataResultModel {
		let authDataResult = try await Auth.auth().signIn(with: credentials)
		return AuthDataResultModel(user: authDataResult.user)
	}

	@discardableResult
	func signInWithApple(credentials: SignInWithAppleResult) async throws -> AuthDataResultModel {
		let credentials = OAuthProvider.credential(withProviderID: AuthProviderOption.apple.rawValue,
		                                           idToken: credentials.token,
		                                           rawNonce: credentials.nonce)
		return try await signIn(with: credentials)
	}
}
