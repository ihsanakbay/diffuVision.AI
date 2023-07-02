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
		case generateButtonDidTapped
		case sizeSelected(size: Size)
		case engineSelected(engineId: String)
		case toggleButton
	}

	enum Output {
		case sizeSelected(size: Size)
		case engineSelected(engineId: String)
		case errorOccured(error: Swift.Error)
		case toggleButton(isEnabled: Bool)
		case imageGenerated(model: GeneratedImageItemModel)
	}

	@Published var request: APIParameters.TextToImageRequest = .init()
	@Published var generatedImageItemModel: GeneratedImageItemModel = .init()
	@Published var selectedSize: Size = .sizes[1]
	@Published var selectedEngineId: String = Constants.engineId
	@Published var engines: [Engine] = .init()
	@Published var prompt: String = ""

	private let output = PassthroughSubject<Output, Never>()
	private var cancellables = Set<AnyCancellable>()

	func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
		input.sink { [weak self] event in
			switch event {
			case .viewDidLoad:
				self?.fetchEngineList()
				self?.checkButtonStatus()
				self?.output.send(.sizeSelected(size: self?.selectedSize ?? .sizes[1]))
				self?.output.send(.engineSelected(engineId: self?.selectedEngineId ?? Constants.engineId))
			case .generateButtonDidTapped:
				self?.generateImage()
			case .sizeSelected(size: let size):
				self?.selectedSize = size
				self?.output.send(.sizeSelected(size: size))
			case .engineSelected(engineId: let id):
				self?.selectedEngineId = id
				self?.output.send(.engineSelected(engineId: id))
			case .toggleButton:
				self?.checkButtonStatus()
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
					self?.output.send(.errorOccured(error: error))
				}
			} receiveValue: { [weak self] response in
				self?.engines = response
			}
			.store(in: &cancellables)
	}

	func generateImage() {
		Spinner.showSpinner()

		request.width = selectedSize.width
		request.height = selectedSize.height

//		if selectedStyle.id != StylePreset.StylePresets.none.rawValue {
//			request.stylePreset = selectedStyle.id
//		}

		let textPrompt = APIParameters.TextPrompt(text: prompt)
		request.textPrompts = [textPrompt]

		ApiClient.dispatch(ApiRouter.GenerateImage(body: request, engine: selectedEngineId))
			.sink { [weak self] completion in
				switch completion {
				case .finished:
					Spinner.hideSpinner()
					Log.info("Image successfully generated")
				case .failure(let error):
					Spinner.hideSpinner()
					Log.error("Unable to generate image: \(error)")
					self?.output.send(.errorOccured(error: error))
				}
			} receiveValue: { [weak self] response in
				Spinner.hideSpinner()
				self?.generatedImageItemModel.response = response
				self?.generatedImageItemModel.promtMessage = self?.request.textPrompts.first?.text
				self?.prompt = ""
				if let model = self?.generatedImageItemModel {
					self?.output.send(.imageGenerated(model: model))
				}
			}
			.store(in: &cancellables)
	}

	func checkButtonStatus() {
		prompt == "" ? output.send(.toggleButton(isEnabled: false)) : output.send(.toggleButton(isEnabled: true))
	}

	func clearAll() {
		generatedImageItemModel.response = nil
	}
}
