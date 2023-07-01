//
//  Spinner.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 1.07.2023.
//

import UIKit

final class Spinner {
	private static var spinnerView: UIView?

	static func showSpinner() {
		DispatchQueue.main.async {
			guard let keyWindow = UIApplication.shared.keyWindow else { return }

			
			spinnerView = UIView(frame: keyWindow.bounds)
			spinnerView?.backgroundColor = Colors.backgroundColor.color.withAlphaComponent(0.5)

			let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
			activityIndicator.center = spinnerView!.center
			activityIndicator.startAnimating()
			spinnerView?.addSubview(activityIndicator)
			keyWindow.addSubview(spinnerView!)
		}
	}

	static func hideSpinner() {
		DispatchQueue.main.async {
			spinnerView?.removeFromSuperview()
			spinnerView = nil
		}
	}
}
