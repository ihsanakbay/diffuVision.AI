//
//  Engine.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 1.07.2023.
//

import Foundation

struct Engine: Codable, Selectable, Identifiable {
	var id: String
	var description: String
	var name: String
	var type: String
	var title: String? {
		return id
	}

	enum CodingKeys: String, CodingKey {
		case id
		case description
		case name
		case type
	}
}
