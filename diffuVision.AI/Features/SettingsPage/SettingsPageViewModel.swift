//
//  SettingsPageViewModel.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 30.06.2023.
//

import UIKit

protocol SettingsPageViewOutput: AnyObject {
	func signOut()
	func deleteAccount()
}

final class SettingsPageViewModel {
	weak var output: SettingsPageViewOutput?

	func signOut() {
		output?.signOut()
	}

	func deleteAccount() {
		output?.deleteAccount()
	}
}
