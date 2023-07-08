//
//  Engine.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 1.07.2023.
//

import Foundation

struct Engine: Codable, Selectable, Identifiable {
	var id: String
	var title: String? {
		return id
	}
}

extension Engine {
	static let engines: [Engine] = [
		Engine(id: "stable-diffusion-512-v2-0"),
		Engine(id: "stable-diffusion-768-v2-0"),
		Engine(id: "stable-diffusion-512-v2-1"),
		Engine(id: "stable-diffusion-768-v2-1")
	]
}
