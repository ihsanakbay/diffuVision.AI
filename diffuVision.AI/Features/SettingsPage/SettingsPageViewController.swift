//
//  SettingsPageViewController.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import UIKit

class SettingsPageViewController: UIViewController {
	private lazy var scrollView = UIScrollView()
	
	private lazy var userView = SettingsItemView()
	private lazy var reviewView = SettingsItemView()
	private lazy var policyView = SettingsItemView()
	private lazy var logoutView = SettingsItemView()
	private lazy var deleteView = SettingsItemView()

	private lazy var appStackView = StackViewFactory.build(
		subviews: [reviewView, policyView],
		axis: .vertical,
		spacing: 16,
		distribution: .fillProportionally)

	private lazy var authStackView = StackViewFactory.build(
		subviews: [logoutView, deleteView],
		axis: .vertical,
		spacing: 16,
		distribution: .fillProportionally)

	private lazy var stackView = StackViewFactory.build(
		subviews: [userView, appStackView, authStackView],
		axis: .vertical,
		spacing: 32,
		distribution: .fillProportionally)

	private let viewModel: SettingsPageViewModel = .init()

	override func viewDidLoad() {
		super.viewDidLoad()
		title = LocaleStrings.tabSettings
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.prefersLargeTitles = true
		setupLayout()
		viewModel.output = self
	}

	private func setupLayout() {
		view.backgroundColor = Colors.backgroundColor.color
		view.addSubview(scrollView)
		
		scrollView.addSubview(stackView)
		scrollView.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.leading.equalToSuperview()
			make.trailing.equalToSuperview()
			make.bottom.equalToSuperview()
		}

		stackView.snp.makeConstraints { make in
			make.top.equalTo(scrollView.snp.top).offset(20)
			make.leading.equalTo(scrollView.snp.leading).offset(20)
			make.trailing.equalTo(scrollView.snp.trailing).offset(-20)
			make.bottom.equalTo(scrollView.snp.bottom).offset(-20)
			make.width.equalTo(scrollView.snp.width).offset(-40)
		}

		userView.configure(iconName: Icons.General.user.rawValue, title: "mymail@mail.com")

		reviewView.configure(iconName: Icons.General.feedback.rawValue, title: LocaleStrings.feedback) {
			print("review")
		}
		policyView.configure(iconName: Icons.General.policy.rawValue, title: LocaleStrings.policy) {
			print("policy")
		}
		logoutView.configure(iconName: Icons.General.logout.rawValue, title: LocaleStrings.logout) {
			let alert = AlertView.showAlertBox(title: LocaleStrings.logout, message: LocaleStrings.logoutConfirmationMessage) { action in
				print(action)
			}
		}
		deleteView.configure(iconName: Icons.General.delete.rawValue, title: LocaleStrings.deleteAccount) {}
	}
}

extension SettingsPageViewController: SettingsPageViewOutput {
	func signOut() {
		alert(message: LocaleStrings.logoutConfirmationMessage, title: LocaleStrings.logout)
	}

	func deleteAccount() {}
}

extension SettingsPageViewController: UIScrollViewDelegate {}
