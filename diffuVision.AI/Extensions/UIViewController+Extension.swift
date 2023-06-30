//
//  UIViewController+Extension.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import UIKit

extension UIViewController {
	func infoAlert(message: String, title: String = "", completion: (() -> Void)? = nil) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: LocaleStrings.ok, style: .default) { _ in
			completion?()
		}
		alertController.addAction(okAction)
		present(alertController, animated: true, completion: nil)
	}

	func confirmAlert(message: String, title: String = "", okHandler: (() -> Void)? = nil) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: LocaleStrings.ok, style: .default) { _ in
			okHandler?()
		}
		let cancelAction = UIAlertAction(title: LocaleStrings.cancel, style: .destructive, handler: nil)
		alertController.addAction(okAction)
		alertController.addAction(cancelAction)
		present(alertController, animated: true, completion: nil)
	}
}
