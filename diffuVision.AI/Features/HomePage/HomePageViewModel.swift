//
//  HomePageViewModel.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import Combine
import Foundation
import StoreKit

final class HomePageViewModel: ObservableObject {
	enum Input {
		case viewDidLoad
		case generateButtonDidTapped
		case sizeSelected(size: Size)
		case engineSelected(engineId: String)
		case cfgScaleSelected(cfgScale: Int)
		case samplerSelected(sampler: SamplerModel)
		case stepsSelected(steps: Int)
		case toggleButton
	}

	enum Output {
		case sizeSelected(size: Size)
		case engineSelected(engineId: String)
		case cfgScaleSelected(cfgScale: Int)
		case samplerSelected(sampler: SamplerModel)
		case stepsSelected(steps: Int)
		case errorOccured(error: Swift.Error)
		case toggleButton(isEnabled: Bool)
		case imageGenerated(model: TextToImageResponse)
	}

	@Published var request: APIParameters.TextToImageRequest = .init()
	@Published var selectedSize: Size = .sizes[1]
	@Published var selectedEngineId: String = Constants.engineId
	@Published var selectedCFGScale: Int = DefaultValues.cfgScale
	@Published var selectedSampler: SamplerModel = .init(name: .AUTO)
	@Published var selectedSteps: Int = DefaultValues.steps
	@Published var engines: [Engine] = .init()
	@Published var prompt: String = ""
	@Published var currentSubscription: Product?
	@Published var status: Product.SubscriptionInfo.Status?
	private let store: StoreKitManager = .init()
	private let output = PassthroughSubject<Output, Never>()
	private var cancellables = Set<AnyCancellable>()

	func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
		input.sink { [weak self] event in
			switch event {
			case .viewDidLoad:
				self?.getCurrentSubscription()
				self?.checkButtonStatus()
				self?.output.send(.sizeSelected(size: self?.selectedSize ?? .sizes[1]))
				self?.output.send(.engineSelected(engineId: self?.selectedEngineId ?? Constants.engineId))
				self?.output.send(.cfgScaleSelected(cfgScale: self?.selectedCFGScale ?? DefaultValues.cfgScale))
				self?.output.send(.samplerSelected(sampler: self?.selectedSampler ?? .init(name: .AUTO)))
				self?.output.send(.stepsSelected(steps: self?.selectedSteps ?? DefaultValues.steps))
			case .generateButtonDidTapped:
				self?.generateImage()
			case .sizeSelected(size: let size):
				self?.selectedSize = size
				self?.output.send(.sizeSelected(size: size))
			case .engineSelected(engineId: let id):
				self?.selectedEngineId = id
				self?.output.send(.engineSelected(engineId: id))
			case .cfgScaleSelected(cfgScale: let cfg):
				self?.selectedCFGScale = cfg
				self?.output.send(.cfgScaleSelected(cfgScale: cfg))
			case .samplerSelected(sampler: let sampler):
				self?.selectedSampler = sampler
				self?.output.send(.samplerSelected(sampler: sampler))
			case .stepsSelected(steps: let steps):
				self?.selectedSteps = steps
				self?.output.send(.stepsSelected(steps: steps))
			case .toggleButton:
				self?.checkButtonStatus()
			}
		}.store(in: &cancellables)

		return output.eraseToAnyPublisher()
	}

	func generateImage() {
		Spinner.showSpinner()

		request.width = selectedSize.width
		request.height = selectedSize.height
		request.cfgScale = selectedCFGScale
		request.steps = selectedSteps

		let samplerName = selectedSampler.name
		if samplerName != .AUTO {
			request.sampler = samplerName.rawValue
		}

		let textPrompt = APIParameters.TextPrompt(text: prompt)
		request.textPrompts = [textPrompt]

		ApiClient.dispatch(ApiRouter.GenerateImage(body: request, engine: selectedEngineId))
			.sink { [weak self] completion in
				switch completion {
				case .finished:
					Spinner.hideSpinner()
					Log.info("Image successfully generated")
					CrashlyticsManager.shared.addLog(message: "Image successfully generated")
				case .failure(let error):
					Spinner.hideSpinner()
					Log.error("Unable to generate image: \(error)")
					CrashlyticsManager.shared.sendNonFatal(error: error)
					self?.output.send(.errorOccured(error: error))
				}
			} receiveValue: { [weak self] response in
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					self?.output.send(.imageGenerated(model: response))
					Spinner.hideSpinner()
					self?.prompt = ""
				}
			}
			.store(in: &cancellables)
	}

	func checkButtonStatus() {
		prompt == "" ? output.send(.toggleButton(isEnabled: false)) : output.send(.toggleButton(isEnabled: true))
	}

	func getCurrentSubscription() {
		currentSubscription = StoreKitManager.shared.purchasedSubscriptions.first
	}
}
