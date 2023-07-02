//
//  SettingsPageViewController.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import Combine
import UIKit

class SettingsPageViewController: UIViewController {
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
		alignment: .fill,
		distribution: .fillProportionally)

	private let viewModel: SettingsPageViewModel = .init()
	private let output = PassthroughSubject<SettingsPageViewModel.Input, Never>()
	private var cancellables = Set<AnyCancellable>()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupLayout()
		observe()
		output.send(.viewDidLoad)
	}

	private func setupLayout() {
		title = LocaleStrings.tabSettings
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationItem.largeTitleDisplayMode = .automatic

		view.backgroundColor = Colors.backgroundColor.color
		view.addSubview(stackView)

		stackView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
			make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
			make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
		}

		reviewView.configure(iconName: Icons.General.feedback.rawValue, title: LocaleStrings.feedback) {
			self.reviewTapped()
		}
		policyView.configure(iconName: Icons.General.policy.rawValue, title: LocaleStrings.policy) {
			self.policyTapped()
		}

		logoutView.configure(iconName: Icons.General.logout.rawValue, title: LocaleStrings.logout) {
			self.confirmAlert(message: LocaleStrings.logoutConfirmationMessage, title: LocaleStrings.logout) {
				self.output.send(.signOutTapped)
			}
		}

		deleteView.configure(iconName: Icons.General.delete.rawValue, title: LocaleStrings.deleteAccount, titleColor: .red) {
			self.confirmAlert(message: LocaleStrings.deleteAccountConfirmationMessage, title: LocaleStrings.deleteAccount) {
				let userId = KeychainItem.currentUserIdentifier
				self.output.send(.deleteAccountTapped(userId: userId))
			}
		}
	}

	private func observe() {
		viewModel.transform(input: output.eraseToAnyPublisher())
			.receive(on: DispatchQueue.main)
			.sink { [weak self] event in
				switch event {
				case .userInfoFetched(user: let user):
					self?.userView.configure(iconName: Icons.General.user.rawValue, title: user.email)
				case .logoutSuccessfully:
					self?.showLoginVC()
				case .deletedSuccessfully:
					self?.showLoginVC()
					self?.infoAlert(message: LocaleStrings.deletedSuccessfully)
				case .errorOccured(error: let error):
					self?.infoAlert(message: error)
				}
			}
			.store(in: &cancellables)
	}
}

extension SettingsPageViewController {
	private func reviewTapped() {
		print(KeychainItem.currentUserName)
		print(KeychainItem.currentUserEmail)
		print(KeychainItem.currentUserIdentifier)
	}

	private func policyTapped() {}

	private func showLoginVC() {
		let loginVC = LoginViewController()
		loginVC.modalPresentationStyle = .fullScreen
		navigationController?.present(loginVC, animated: true)
	}
}
