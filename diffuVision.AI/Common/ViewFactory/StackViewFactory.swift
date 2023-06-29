//
//  StackViewFactory.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import UIKit

enum StackViewFactory {
	static func build(
		subviews: [UIView],
		axis: NSLayoutConstraint.Axis,
		spacing: CGFloat,
		alignment: UIStackView.Alignment = .fill,
		distribution: UIStackView.Distribution = .fill
	) -> UIStackView {
		let stackView = UIStackView(arrangedSubviews: subviews)
		stackView.axis = axis
		stackView.spacing = spacing
		stackView.alignment = alignment
		stackView.distribution = distribution
		return stackView
	}
}
