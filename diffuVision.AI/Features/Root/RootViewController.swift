//
//  RootViewController.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import UIKit

class RootViewController: UIViewController {
	private let viewModel: RootViewModel

	init(viewModel: RootViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		viewModel.output = self
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.checkAuth()
	}
}

extension RootViewController: RootViewModelOutput {
	func showLoginPage() {
		let loginVC = LoginViewController()
		loginVC.modalPresentationStyle = .fullScreen
		navigationController?.present(loginVC, animated: true)
	}

	func showMainPage() {
		let mainTabBarVC = MainTabBarController()
		mainTabBarVC.modalPresentationStyle = .fullScreen
		navigationController?.present(mainTabBarVC, animated: true)
	}

	fileprivate func createNavController(
		for rootViewController: UIViewController,
		title: String,
		navBarHidden: Bool) -> UIViewController
	{
		let navController = UINavigationController(rootViewController: rootViewController)
		navController.navigationBar.prefersLargeTitles = false
		navController.isNavigationBarHidden = navBarHidden
		rootViewController.navigationItem.title = title
		return navController
	}
}
