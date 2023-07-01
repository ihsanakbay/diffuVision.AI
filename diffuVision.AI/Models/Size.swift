//
//  Size.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import Foundation

protocol Selectable: Hashable {
	var title: String? { get }
}

struct Size: Selectable {
	let id = UUID()
	let width: Int
	let height: Int
	var title: String?

	init(width: Int, height: Int) {
		self.width = width
		self.height = height
		self.title = "\(width) x \(height)"
	}

	enum CodingKeys: CodingKey {
		case id
		case width
		case height
		case title
	}
}

extension Size {
	static let sizes: [Size] = [
		Size(width: 256, height: 256),
		Size(width: 512, height: 512),
		Size(width: 768, height: 768),
		Size(width: 1024, height: 1024),
	]
}
