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
		view.backgroundColor = .systemBackground
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
		let mainVC = createNavController(for: MainViewController(), title: LocaleStrings.appTitle)
		mainVC.modalPresentationStyle = .fullScreen
		navigationController?.present(mainVC, animated: true)
	}

	fileprivate func createNavController(
		for rootViewController: UIViewController,
		title: String) -> UIViewController
	{
		let navController = UINavigationController(rootViewController: rootViewController)
		navController.navigationBar.prefersLargeTitles = false
		rootViewController.navigationItem.title = title
		return navController
	}
}
