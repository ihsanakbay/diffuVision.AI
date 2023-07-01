//
//  Icons.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import UIKit

struct Icons {
	enum TabView: String {
		case generatorTab = "wand.and.stars"
		case settingsTab = "gearshape.fill"

		var image: UIImage {
			return UIImage(systemName: self.rawValue)!
		}
	}

	enum General: String {
		case xMarkOctagon = "xmark.octagon"
		case xMarkCircle = "xmark.circle.fill"
		case logout = "power.circle.fill"
		case delete = "trash.fill"
		case user = "person.fill"
		case download = "square.and.arrow.down"
		case share = "square.and.arrow.up"
		case regenerate = "arrow.triangle.2.circlepath"
		case send = "paperplane.fill"
		case policy = "exclamationmark.shield.fill"
		case feedback = "quote.bubble.fill"
		case premium = "crown.fill"
		case checkmark
		case copyFill = "doc.on.doc.fill"
		case copy = "doc.on.doc"

		var image: UIImage {
			return UIImage(systemName: self.rawValue)!
		}
	}
}
