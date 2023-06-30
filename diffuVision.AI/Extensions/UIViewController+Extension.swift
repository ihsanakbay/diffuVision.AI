//
//  UIViewController+Extension.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import UIKit

extension UIViewController {
	func alert(message: String, title: String = "") {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let OKAction = UIAlertAction(title: LocaleStrings.ok, style: .default, handler: nil)
		alertController.addAction(OKAction)
		present(alertController, animated: true, completion: nil)
	}
}
