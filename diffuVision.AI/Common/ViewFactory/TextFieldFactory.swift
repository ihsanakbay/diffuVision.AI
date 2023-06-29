//
//  TextFieldFactory.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import SnapKit
import UIKit

enum TextFieldFactory {
	static func build(
		placeholder: String,
		isSecure: Bool = false,
		backgroundColor: UIColor = Colors.secondaryBackgroundColor.color,
		foregroundColor: UIColor = Colors.textColor.color,
		autoCorrection: UITextAutocorrectionType = .default,
		autoCapitalized: UITextAutocapitalizationType = .sentences
	) -> UITextField {
		let spacer = UIView()
		spacer.snp.makeConstraints { make in
			make.width.equalTo(12)
			make.height.equalTo(50)
		}
		let tf = UITextField()
		tf.leftView = spacer
		tf.leftViewMode = .always
		tf.textColor = foregroundColor
		tf.backgroundColor = backgroundColor
		tf.isSecureTextEntry = isSecure
		tf.borderStyle = .none
		tf.layer.cornerRadius = 12
		tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
		tf.autocorrectionType = autoCorrection
		tf.autocapitalizationType = autoCapitalized
		return tf
	}
}
