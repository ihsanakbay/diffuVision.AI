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
		case engineSelected(engineId: String)
	}

	enum Output {
		case sizeSelected(size: Size)
		case engineSelected(engineId: String)
	}

	@Published var request: APIParameters.TextToImageRequest = .init()
	@Published var generatedImageItemModel: GeneratedImageItemModel = .init()
	@Published var selectedSize: Size = .sizes[1]
	@Published var selectedEngineId: String = Constants.engineId
	@Published var engines: [Engine] = .init()
	@Published var errorMessage: Swift.Error?
	@Published var isGenerating: Bool = false
	@Published var prompt: String = ""

	private let output = PassthroughSubject<Output, Never>()
	private var cancellables = Set<AnyCancellable>()

	func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
		input.sink { [weak self] event in
			switch event {
			case .viewDidLoad:
				self?.fetchEngineList()
				self?.output.send(.sizeSelected(size: self?.selectedSize ?? .sizes[1]))
				self?.output.send(.engineSelected(engineId: self?.selectedEngineId ?? Constants.engineId))
			case .sizeSelected(size: let size):
				self?.selectedSize = size
				self?.output.send(.sizeSelected(size: size))
			case .engineSelected(engineId: let id):
				self?.selectedEngineId = id
				self?.output.send(.engineSelected(engineId: id))
			}
		}.store(in: &cancellables)

		return output.eraseToAnyPublisher()
	}

	func fetchEngineList() {
		ApiClient.dispatch(ApiRouter.FetchEngineList())
			.sink { [weak self] completion in
				switch completion {
				case .finished:
					Log.info("Successfully fetched models")
				case .failure(let error):
					Log.error("Unable to fetched models \(error)")
					self?.errorMessage = error
				}
			} receiveValue: { [weak self] response in
				self?.engines = response
			}
			.store(in: &cancellables)
	}

	func generateImage() {
		isGenerating = true
		request.width = selectedSize.width
		request.height = selectedSize.height

		ApiClient.dispatch(ApiRouter.GenerateImage(body: request, engine: selectedEngineId))
			.sink { [weak self] completion in
				self?.isGenerating = false
				switch completion {
				case .finished:
					Log.info("Image successfully generated")
				case .failure(let error):
					Log.error("Unable to generate image: \(error)")
					self?.errorMessage = error
				}
			} receiveValue: { [weak self] response in
				self?.generatedImageItemModel.response = response
				self?.generatedImageItemModel.promtMessage = self?.request.textPrompts.first?.text
				self?.prompt = ""
			}
			.store(in: &cancellables)
	}

	func clearAll() {
		generatedImageItemModel.response = nil
	}
}
