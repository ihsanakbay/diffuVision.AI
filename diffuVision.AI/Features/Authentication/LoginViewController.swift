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
		button.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
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

	// MARK: from Apple's login app

	// - Tag: perform_appleid_password_request
	/// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
	func performExistingAccountSetupFlows() {
		// Prepare requests for both Apple ID and password providers.
		let requests = [ASAuthorizationAppleIDProvider().createRequest(),
		                ASAuthorizationPasswordProvider().createRequest()]

		// Create an authorization controller with the given requests.
		let authorizationController = ASAuthorizationController(authorizationRequests: requests)
		authorizationController.delegate = self
		authorizationController.presentationContextProvider = self
		authorizationController.performRequests()
	}

	/// - Tag: perform_appleid_request
	@objc func handleAuthorizationAppleIDButtonPress() {
		let appleIDProvider = ASAuthorizationAppleIDProvider()
		let request = appleIDProvider.createRequest()
		request.requestedScopes = [.fullName, .email]

		let authorizationController = ASAuthorizationController(authorizationRequests: [request])
		authorizationController.delegate = self
		authorizationController.presentationContextProvider = self
		authorizationController.performRequests()
	}
}

// MARK: ASAuthorizationControllerDelegate

extension LoginViewController: ASAuthorizationControllerDelegate {
	/// - Tag: did_complete_authorization
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		switch authorization.credential {
		case let appleIDCredential as ASAuthorizationAppleIDCredential:
			// Create an account in your system.
			let userIdentifier = appleIDCredential.user
			let fullName = "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")"
			let email = appleIDCredential.email ?? ""

			let user = DBUser(uid: userIdentifier, email: email, fullName: fullName)
			Task {
				let dbUser = await UserManager.shared.getUser(userId: userIdentifier)
				saveUserInKeychain(userIdentifier, fullName, email)
				do {
					if dbUser == nil {
						try await UserManager.shared.createNewUser(user: user)
					}
				} catch {
					self.infoAlert(message: error.localizedDescription, title: LocaleStrings.errorTitle)
				}
			}
			showMainViewController()

		default:
			break
		}
	}

	private func saveUserInKeychain(_ userIdentifier: String, _ fullName: String, _ email: String) {
		output.send(.saveUserToKeychain(userIdentifier, fullName, email))
	}

	private func showMainViewController() {
		let mainTabBarVC = MainTabBarController()
		mainTabBarVC.modalPresentationStyle = .fullScreen
		mainTabBarVC.isModalInPresentation = false
		mainTabBarVC.selectedIndex = 0
		DispatchQueue.main.async {
			self.dismiss(animated: true) {
				if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
				   let delegate = windowScene.delegate as? SceneDelegate,
				   let window = delegate.window
				{
					window.rootViewController = mainTabBarVC
				}
			}
		}
	}

	/// - Tag: did_complete_error
	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
		infoAlert(message: error.localizedDescription, title: LocaleStrings.errorTitle)
	}
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
	/// - Tag: provide_presentation_anchor
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		return view.window!
	}
}
