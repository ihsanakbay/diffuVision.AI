//
//  SettingsModel.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 30.06.2023.
//

import UIKit

struct SettingsModel: Hashable {
	var title: String
	var icon: String
	var titleColor: UIColor?
}

extension SettingsModel {
	static let userModels: [SettingsModel] = [
		SettingsModel(title: "mymail@test.com", icon: Icons.General.user.rawValue)
	]

	static let appModels: [SettingsModel] = [
		SettingsModel(title: LocaleStrings.feedback, icon: Icons.General.feedback.rawValue),
		SettingsModel(title: LocaleStrings.policy, icon: Icons.General.policy.rawValue)
	]

	static let authModels: [SettingsModel] = [
		SettingsModel(title: LocaleStrings.logout, icon: Icons.General.logout.rawValue, titleColor: .red),
		SettingsModel(title: LocaleStrings.deleteAccount, icon: Icons.General.delete.rawValue, titleColor: .red)
	]
}
