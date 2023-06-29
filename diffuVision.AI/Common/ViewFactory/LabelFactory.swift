//
//  LabelFactory.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import UIKit

enum LabelFactory {
	static func build(
		text: String? = nil,
		font: UIFont,
		backgroundColor: UIColor = .clear,
		textColor: UIColor = Colors.textColor.color,
		textAlignment: NSTextAlignment = .center
	) -> UILabel {
		let label = UILabel()
		label.text = text
		label.font = font
		label.backgroundColor = backgroundColor
		label.textColor = textColor
		label.textAlignment = textAlignment
		return label
	}
}
