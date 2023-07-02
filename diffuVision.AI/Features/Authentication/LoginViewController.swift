//
//  LoginViewController.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import AuthenticationServices
import Combine
import SnapKit
import UIKit

class LoginViewController: UIViewController {
	private let titleLabel: UILabel = LabelFactory.build(
		text: LocaleStrings.appTitle,
		font: UIFont.systemFont(ofSize: 36, weight: .bold),
		textColor: Colors.textColor.color,
		textAlignment: .center)

	private let descriptionLabel: UILabel = {
		let label = LabelFactory.build(
			text: LocaleStrings.appDescription,
			font: UIFont.systemFont(ofSize: 24, weight: .semibold),
			textColor: Colors.textColor.color,
			textAlignment: .center)
		label.numberOfLines = 0
		return label
	}()

	private let onboardMessageLabel: UILabel = {
		let label = LabelFactory.build(
			text: LocaleStrings.onboardMessage,
			font: UIFont.systemFont(ofSize: 18),
			textColor: Colors.textColor.color,
			textAlignment: .center)
		label.numberOfLines = 0
		return label
	}()

	private lazy var labelStack = StackViewFactory.build(
		subviews: [titleLabel, descriptionLabel, onboardMessageLabel],
		axis: .vertical,
		spacing: 16,
		alignment: .fill,
		distribution: .fillProportionally)

	private lazy var appleButton: ASAuthorizationAppleIDButton = {
		let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
		button.addTarget(self, action: #selector(handleLogInWithAppleID), for: .touchUpInside)
		return button
	}()

	private let viewModel: LoginViewModel = .init()
	private let output = PassthroughSubject<LoginViewModel.Input, Never>()
	private var cancellables = Set<AnyCancellable>()

	override func loadView() {
		super.loadView()
		view = GradientView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupLayout()
		observe()
	}

	private func setupLayout() {
		view.addSubview(labelStack)
		labelStack.snp.makeConstraints { make in
			make.centerY.equalTo(view.snp.centerY)
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalToSuperview().offset(-20)
		}

		view.addSubview(appleButton)
		appleButton.snp.makeConstraints { make in
			make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
			make.leading.equalToSuperview().offset(40)
			make.trailing.equalToSuperview().offset(-40)
			make.height.equalTo(50)
		}
	}

	private func observe() {
		viewModel.transform(input: output.eraseToAnyPublisher())
			.receive(on: DispatchQueue.main)
			.sink { [weak self] event in
				switch event {
				case .successfullySignedInWithApple:
					break
				case .errorOccured(error: let error):
					self?.infoAlert(message: error.localizedDescription, title: LocaleStrings.error)
				}
			}
			.store(in: &cancellables)
	}
}

extension LoginViewController {
	@objc private func handleLogInWithAppleID() {}
}
