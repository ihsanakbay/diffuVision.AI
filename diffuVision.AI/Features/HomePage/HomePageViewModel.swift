//
//  HomePageViewModel.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import Combine
import Foundation

final class HomePageViewModel: ObservableObject {
	enum Input {
		case viewDidLoad
		case sizeSelected(size: Size)
	}

	enum Output {
		case sizeSelected(size: Size)
	}

	@Published var selectedSize: Size = .sizes[1]

	private let output = PassthroughSubject<Output, Never>()
	private var cancellables = Set<AnyCancellable>()

	func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
		input.sink { [weak self] event in
			switch event {
			case .viewDidLoad:
				self?.output.send(.sizeSelected(size: self?.selectedSize ?? .sizes[1]))
			case .sizeSelected(size: let size):
				self?.selectedSize = size
				self?.output.send(.sizeSelected(size: size))
			}
		}.store(in: &cancellables)

		return output.eraseToAnyPublisher()
	}
}
