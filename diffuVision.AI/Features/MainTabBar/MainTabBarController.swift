//
//  MainTabBarController.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupTabs()
		self.setupTabBar()
	}

	private func setupTabBar() {
		self.tabBar.tintColor = Colors.accentColor.color
	}

	private func setupTabs() {
		// MARK: Home page

		let homePageViewModel = HomePageViewModel()
		let homePageViewController = HomePageViewController(viewModel: homePageViewModel)
		let homePage = self.createNav("",
		                              image: Icons.TabView.generatorTab.image,
		                              navTitle: LocaleStrings.appTitle,
		                              viewController: homePageViewController)

		// MARK: Settings page

		let settingsPageViewController = SettingsPageViewController()
		let settingsPage = self.createNav("",
		                                  image: Icons.TabView.settingsTab.image,
		                                  navTitle: LocaleStrings.tabSettings,
		                                  viewController: settingsPageViewController)

		self.setViewControllers([homePage, settingsPage], animated: true)
	}
}

// MARK: Helper methods

extension MainTabBarController {
	private func createNav(_ title: String,
	                       image: UIImage?,
	                       navTitle: String, viewController: UIViewController) -> UINavigationController
	{
		let nav = UINavigationController(rootViewController: viewController)
		nav.tabBarItem.title = title
		nav.tabBarItem.image = image
		nav.viewControllers.first?.navigationItem.title = navTitle
		return nav
	}
}
