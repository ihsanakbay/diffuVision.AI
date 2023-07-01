//
//  CrashlyticsManager.swift
//  diffuVision
//
//  Created by İhsan Akbay on 18.06.2023.
//

import FirebaseCrashlytics
import Foundation

final class CrashlyticsManager {
	static let shared = CrashlyticsManager()
	private init() {}

	func setUserId(userId: String) {
		Crashlytics.crashlytics().setUserID(userId)
	}

	func setValue(value: String, key: String) {
		Crashlytics.crashlytics().setCustomValue(value, forKey: key)
	}

	func addLog(message: String) {
		Crashlytics.crashlytics().log(message)
	}
	
	func sendNonFatal(error: Error) {
		Crashlytics.crashlytics().record(error: error)
	}
}
