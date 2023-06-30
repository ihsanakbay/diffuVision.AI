//
//  UIAlertController+Extension.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 30.06.2023.
//

import UIKit

struct AlertView {
	public static func showAlertBox(title: String, message: String, handler: ((UIAlertAction) -> Void)?) -> UIAlertController {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: LocaleStrings.ok, style: .cancel, handler: handler))
		return alert
	}
}

extension UIAlertController {
	func present(on viewController: UIViewController, completion: (() -> Void)? = nil) {
		viewController.present(self, animated: true, completion: completion)
	}
}
