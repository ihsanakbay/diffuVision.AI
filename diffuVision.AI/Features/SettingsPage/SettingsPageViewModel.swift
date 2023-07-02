//
//  SettingsPageViewModel.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 30.06.2023.
//

import Combine
import UIKit

final class SettingsPageViewModel {
	enum Input {
		case viewDidLoad
		case signOutTapped
		case deleteAccountTapped(userId: String)
	}

	enum Output {
		case userInfoFetched(user: DBUser)
		case logoutSuccessfully
		case deletedSuccessfully
		case errorOccured(error: String)
	}

	private let output = PassthroughSubject<Output, Never>()
	private var cancellables = Set<AnyCancellable>()

	func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
		input.sink { [weak self] event in
			switch event {
			case .viewDidLoad:
				self?.fetchUserInfo()
			case .signOutTapped:
				self?.signOut()
			case .deleteAccountTapped(userId: let uid):
				self?.deleteAccount(userId: uid)
			}
		}.store(in: &cancellables)

		return output.eraseToAnyPublisher()
	}

	func fetchUserInfo() {
		let userId = KeychainItem.currentUserIdentifier
		Task {
			let user = await UserManager.shared.getUser(userId: userId)
			if let user = user {
				self.output.send(.userInfoFetched(user: user))
			}
		}
	}

	func signOut() {
		KeychainItem.deleteUserFromKeychain()
		output.send(.logoutSuccessfully)
	}

	func deleteAccount(userId: String) {
		Task {
			do {
				try await UserManager.shared.deactivateUser(userId: userId)
				KeychainItem.deleteUserFromKeychain()
				self.output.send(.deletedSuccessfully)
			} catch {
				self.output.send(.errorOccured(error: LocaleStrings.errorTitle))
			}
		}
	}
}
