//
//  UserManager.swift
//  diffuVision
//
//  Created by İhsan Akbay on 18.06.2023.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class UserManager {
	static let shared = UserManager()
	private init() {}
	
	private let userCollection = Firestore.firestore().collection("users")
	
	private func userDocument(userId: String) -> DocumentReference {
		userCollection.document(userId)
	}
	
	func createNewUser(user: DBUser) async throws {
		try userDocument(userId: user.uid).setData(from: user, merge: false)
	}
	
	func getUser(userId: String) async throws -> DBUser {
		try await userDocument(userId: userId).getDocument(as: DBUser.self)
	}
	
	func deleteUser(userId: String) async throws {
		try await userDocument(userId: userId).delete()
	}
	
	func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
		let data: [String: Any] = [
			DBUser.CodingKeys.isPremium.rawValue: isPremium
		]
		try await userDocument(userId: userId).updateData(data)
	}
}
