//
//  LoginViewModel.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 2.07.2023.
//

import Combine
import Foundation

final class LoginViewModel: ObservableObject {
	enum Input {
		case signInWithAppleButtonDidTapped
	}

	enum Output {
		case successfullySignedInWithApple
		case errorOccured(error: Swift.Error)
	}

	private let output = PassthroughSubject<Output, Never>()
	private var cancellables = Set<AnyCancellable>()

	func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
		input.sink { [weak self] event in
			switch event {
			case .signInWithAppleButtonDidTapped:
				self?.signInWithApple()
			}
		}.store(in: &cancellables)

		return output.eraseToAnyPublisher()
	}

	func signInWithApple() {
		output.send(.successfullySignedInWithApple)
	}
}
