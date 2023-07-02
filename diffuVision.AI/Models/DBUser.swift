//
//  DBUser.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 2.07.2023.
//

import Foundation

struct DBUser: Codable {
	var uid: String
	var email: String
	var fullName: String
	var isAccountDeleted: Bool = false
	var createdAt: Date = .init()

	enum CodingKeys: String, CodingKey {
		case uid
		case email
		case fullName = "full_name"
		case isAccountDeleted = "is_account_deleted"
		case createdAt = "created_at"
	}
}
