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
//		self.tabBar.barTintColor =
//		self.tabBar.tintColor =
	}

	private func setupTabs() {
		let homePage = self.createNav("",
		                              image: Icons.TabView.generatorTab.image,
		                              navTitle: LocaleStrings.appTitle,
		                              viewController: HomePageViewController())
		let settingsPage = self.createNav("",
		                                  image: Icons.TabView.settingsTab.image,
		                                  navTitle: LocaleStrings.tabSettings,
		                                  viewController: SettingsPageViewController())

		self.setViewControllers([homePage, settingsPage], animated: true)
	}

	private func createNav(_ title: String, image: UIImage?, navTitle: String, viewController: UIViewController) -> UINavigationController {
		let nav = UINavigationController(rootViewController: viewController)
		nav.tabBarItem.title = title
		nav.tabBarItem.image = image
		nav.viewControllers.first?.navigationItem.title = navTitle
		return nav
	}
}
