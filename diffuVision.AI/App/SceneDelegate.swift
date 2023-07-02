//
//  SceneDelegate.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }

		let window = UIWindow(windowScene: windowScene)

		let rootViewModel = RootViewModel()
		let rootViewController = RootViewController(viewModel: rootViewModel)
		window.rootViewController = UINavigationController(rootViewController: rootViewController)
		self.window = window
		window.makeKeyAndVisible()
	}
}

extension SceneDelegate {
	func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
		guard animated, let window = window else {
			self.window?.rootViewController = vc
			self.window?.makeKeyAndVisible()
			return
		}

		window.rootViewController = vc
		window.makeKeyAndVisible()
		UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve,
		                  animations: nil, completion: nil)
	}
}
