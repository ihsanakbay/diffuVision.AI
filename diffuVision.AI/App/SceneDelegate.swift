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

		#warning("dont forget this")
//		let loginStorageService: LoginStorageService = LoginStorageManager()
		let rootViewModel = RootViewModel()
		let rootViewController = RootViewController(viewModel: rootViewModel)
		window.rootViewController = UINavigationController(rootViewController: rootViewController)
		self.window = window
		window.makeKeyAndVisible()
	}
}
