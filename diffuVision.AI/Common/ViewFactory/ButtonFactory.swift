//
//  ButtonFactory.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import UIKit

struct ButtonFactory {
	static func build(
		text: String,
		buttonStyle: UIButton.Configuration = .filled(),
		foregroundColor: UIColor = Colors.textColor.color,
		backgroundColor: UIColor = Colors.accentColor.color,
		image: UIImage? = nil,
		imagePadding: CGFloat = 8,
		imagePlacement: NSDirectionalRectEdge = .leading,
		cornerStyle: UIButton.Configuration.CornerStyle = .capsule,
		contentAlignment: UIControl.ContentHorizontalAlignment = .center,
		action: (() -> Void)? = nil
	) -> UIButton {
		let button = UIButton()
		button.configuration = .filled()
		button.configuration?.title = text
		button.configuration?.baseForegroundColor = foregroundColor
		button.configuration?.baseBackgroundColor = backgroundColor
		button.configuration?.image = image
		button.configuration?.imagePadding = imagePadding
		button.configuration?.imagePlacement = imagePlacement
		button.configuration?.cornerStyle = cornerStyle
		button.contentHorizontalAlignment = contentAlignment
		
		button.addAction(UIAction { _ in
			action?()
		}, for: .touchUpInside)

		return button
	}
}
