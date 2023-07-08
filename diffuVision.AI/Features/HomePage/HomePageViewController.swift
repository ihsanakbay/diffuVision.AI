//
//  HomePageViewController.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import Combine
import SnapKit
import UIKit

class HomePageViewController: UIViewController {
	// MARK: Size

	private let sizeView: UIView = {
		let view = UIView()
		view.backgroundColor = Colors.secondaryBackgroundColor.color
		view.layer.cornerRadius = 10
		view.layer.shadowColor = UIColor.white.cgColor
		view.layer.shadowOpacity = 0.25
		view.layer.shadowOffset = CGSize(width: 0, height: 0)
		view.layer.shadowRadius = 1
		return view
	}()

	private lazy var sizeButton: UIButton = {
		let button = ButtonFactory.build(
			text: LocaleStrings.selectSize,
			buttonStyle: .plain(),
			backgroundColor: .clear,
			contentAlignment: .leading)
		button.isUserInteractionEnabled = false
		return button
	}()

	private let sizeLabel: UILabel = LabelFactory.build(font: UIFont.systemFont(ofSize: 16),
	                                                    textColor: Colors.textColor.color,
	                                                    textAlignment: .right)

	// MARK: Engine

	private let engineView: UIView = {
		let view = UIView()
		view.backgroundColor = Colors.secondaryBackgroundColor.color
		view.layer.cornerRadius = 10
		view.layer.shadowColor = UIColor.white.cgColor
		view.layer.shadowOpacity = 0.25
		view.layer.shadowOffset = CGSize(width: 0, height: 0)
		view.layer.shadowRadius = 1
		return view
	}()

	private lazy var engineButton: UIButton = {
		let button = ButtonFactory.build(
			text: LocaleStrings.selectEngine,
			buttonStyle: .plain(),
			backgroundColor: .clear,
			contentAlignment: .leading)
		button.isUserInteractionEnabled = false
		return button
	}()

	private let engineLabel: UILabel = LabelFactory.build(font: UIFont.systemFont(ofSize: 16),
	                                                      textColor: Colors.textColor.color,
	                                                      textAlignment: .right)

	// MARK: CFG

	private let cfgView: UIView = {
		let view = UIView()
		view.backgroundColor = Colors.secondaryBackgroundColor.color
		view.layer.cornerRadius = 10
		view.layer.shadowColor = UIColor.white.cgColor
		view.layer.shadowOpacity = 0.25
		view.layer.shadowOffset = CGSize(width: 0, height: 0)
		view.layer.shadowRadius = 1
		return view
	}()

	private lazy var cfgButton: UIButton = {
		let button = ButtonFactory.build(
			text: "CFG Scale",
			buttonStyle: .plain(),
			backgroundColor: .clear,
			contentAlignment: .leading)
		button.isUserInteractionEnabled = false
		return button
	}()

	private let cfgLabel: UILabel = LabelFactory.build(font: UIFont.systemFont(ofSize: 16),
	                                                   textColor: Colors.textColor.color,
	                                                   textAlignment: .right)

	// MARK: sampler

	private let samplerView: UIView = {
		let view = UIView()
		view.backgroundColor = Colors.secondaryBackgroundColor.color
		view.layer.cornerRadius = 10
		view.layer.shadowColor = UIColor.white.cgColor
		view.layer.shadowOpacity = 0.25
		view.layer.shadowOffset = CGSize(width: 0, height: 0)
		view.layer.shadowRadius = 1
		return view
	}()

	private lazy var samplerButton: UIButton = {
		let button = ButtonFactory.build(
			text: LocaleStrings.sampler,
			buttonStyle: .plain(),
			backgroundColor: .clear,
			contentAlignment: .leading)
		button.isUserInteractionEnabled = false
		return button
	}()

	private let samplerLabel: UILabel = LabelFactory.build(font: UIFont.systemFont(ofSize: 16),
	                                                       textColor: Colors.textColor.color,
	                                                       textAlignment: .right)

	// MARK: Steps

	private let stepsView: UIView = {
		let view = UIView()
		view.backgroundColor = Colors.secondaryBackgroundColor.color
		view.layer.cornerRadius = 10
		view.layer.shadowColor = UIColor.white.cgColor
		view.layer.shadowOpacity = 0.25
		view.layer.shadowOffset = CGSize(width: 0, height: 0)
		view.layer.shadowRadius = 1
		return view
	}()

	private lazy var stepsButton: UIButton = {
		let button = ButtonFactory.build(
			text: LocaleStrings.steps,
			buttonStyle: .plain(),
			backgroundColor: .clear,
			contentAlignment: .leading)
		button.isUserInteractionEnabled = false
		return button
	}()

	private let stepsLabel: UILabel = LabelFactory.build(font: UIFont.systemFont(ofSize: 16),
	                                                     textColor: Colors.textColor.color,
	                                                     textAlignment: .right)

	private let emptyLabel: UILabel = {
		let label = LabelFactory.build(text: LocaleStrings.dashboardTitle,
		                               font: UIFont.systemFont(ofSize: 18),
		                               backgroundColor: .clear,
		                               textColor: Colors.textColor.color,
		                               textAlignment: .center)
		label.numberOfLines = 0
		return label
	}()

	private lazy var textView: UITextView = {
		let textView = UITextView()
		textView.isScrollEnabled = false
		textView.layer.cornerRadius = 10
		textView.backgroundColor = Colors.secondaryBackgroundColor.color
		textView.textColor = Colors.textColor.color
		textView.font = UIFont.systemFont(ofSize: 16)
		textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
		return textView
	}()

	private lazy var generateButton: UIButton = ButtonFactory.build(text: "",
	                                                                image: Icons.General.send.image,
	                                                                imagePadding: 0,
	                                                                cornerStyle: .large)
	{
		Task {
			self.viewModel.getCurrentSubscription()
			if let plan = self.viewModel.currentSubscription {
				self.output.send(.generateButtonDidTapped)
			} else {
				self.showPremium()
			}
		}
	}

	private lazy var promptStackView = StackViewFactory.build(
		subviews: [textView, generateButton],
		axis: .horizontal,
		spacing: 16,
		alignment: .center,
		distribution: .fillProportionally)

	private let viewModel: HomePageViewModel = .init()
	private let output = PassthroughSubject<HomePageViewModel.Input, Never>()
	private var cancellables = Set<AnyCancellable>()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupLayout()
		observe()
		output.send(.viewDidLoad)
	}

	private func setupLayout() {
		view.backgroundColor = Colors.backgroundColor.color
		setupTextView()

		// MARK: Size

		let sizeTap = UITapGestureRecognizer(target: self, action: #selector(selectSize(_:)))
		sizeView.addGestureRecognizer(sizeTap)
		sizeView.addSubview(sizeButton)
		sizeView.addSubview(sizeLabel)
		view.addSubview(sizeView)
		sizeView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalToSuperview().offset(-20)
			make.height.equalTo(40)
		}

		sizeButton.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.bottom.equalToSuperview()
			make.leading.equalToSuperview()
			make.trailing.equalTo(sizeLabel.snp.leading).offset(16)
			make.height.equalTo(40)
		}

		sizeLabel.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(-16)
			make.centerY.equalToSuperview()
			make.height.equalTo(40)
		}

		// MARK: Engine

		let engineTap = UITapGestureRecognizer(target: self, action: #selector(selectEngine(_:)))
		engineView.addGestureRecognizer(engineTap)
		engineView.addSubview(engineButton)
		engineView.addSubview(engineLabel)
		view.addSubview(engineView)
		engineView.snp.makeConstraints { make in
			make.top.equalTo(sizeView.snp.bottom).offset(10)
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalToSuperview().offset(-20)
			make.height.equalTo(40)
		}

		engineButton.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.bottom.equalToSuperview()
			make.leading.equalToSuperview()
			make.trailing.equalTo(engineLabel.snp.leading).offset(16)
			make.height.equalTo(40)
		}

		engineLabel.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(-16)
			make.centerY.equalToSuperview()
			make.height.equalTo(40)
		}

		// MARK: CFG

		let cfgTap = UITapGestureRecognizer(target: self, action: #selector(selectCFG(_:)))
		cfgView.addGestureRecognizer(cfgTap)
		cfgView.addSubview(cfgButton)
		cfgView.addSubview(cfgLabel)
		view.addSubview(cfgView)
		cfgView.snp.makeConstraints { make in
			make.top.equalTo(engineView.snp.bottom).offset(10)
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalToSuperview().offset(-20)
			make.height.equalTo(40)
		}

		cfgButton.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.bottom.equalToSuperview()
			make.leading.equalToSuperview()
			make.trailing.equalTo(cfgLabel.snp.leading).offset(16)
			make.height.equalTo(40)
		}

		cfgLabel.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(-16)
			make.centerY.equalToSuperview()
			make.height.equalTo(40)
		}

		// MARK: Sampler

		let samplerTap = UITapGestureRecognizer(target: self, action: #selector(selectSampler(_:)))
		samplerView.addGestureRecognizer(samplerTap)
		samplerView.addSubview(samplerButton)
		samplerView.addSubview(samplerLabel)
		view.addSubview(samplerView)
		samplerView.snp.makeConstraints { make in
			make.top.equalTo(cfgView.snp.bottom).offset(10)
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalToSuperview().offset(-20)
			make.height.equalTo(40)
		}

		samplerButton.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.bottom.equalToSuperview()
			make.leading.equalToSuperview()
			make.trailing.equalTo(samplerLabel.snp.leading).offset(16)
			make.height.equalTo(40)
		}

		samplerLabel.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(-16)
			make.centerY.equalToSuperview()
			make.height.equalTo(40)
		}

		// MARK: Steps

		let stepsTap = UITapGestureRecognizer(target: self, action: #selector(selectSteps(_:)))
		stepsView.addGestureRecognizer(stepsTap)
		stepsView.addSubview(stepsButton)
		stepsView.addSubview(stepsLabel)
		view.addSubview(stepsView)
		stepsView.snp.makeConstraints { make in
			make.top.equalTo(samplerView.snp.bottom).offset(10)
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalToSuperview().offset(-20)
			make.height.equalTo(40)
		}

		stepsButton.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.bottom.equalToSuperview()
			make.leading.equalToSuperview()
			make.trailing.equalTo(stepsLabel.snp.leading).offset(16)
			make.height.equalTo(40)
		}

		stepsLabel.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(-16)
			make.centerY.equalToSuperview()
			make.height.equalTo(40)
		}

		// MARK: Empty view

		view.addSubview(emptyLabel)
		emptyLabel.snp.makeConstraints { make in
			make.top.equalTo(stepsView.snp.bottom).offset(40)
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalToSuperview().offset(-20)
		}

		// MARK: Prompt

		view.addSubview(promptStackView)
		promptStackView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalToSuperview().offset(-20)
			make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-20)
		}

		textView.snp.makeConstraints { make in
			make.leading.top.bottom.equalToSuperview()
			make.trailing.equalTo(generateButton.snp.leading).offset(-16)
		}

		generateButton.snp.makeConstraints { make in
			make.height.width.equalTo(40)
		}
	}

	private func observe() {
		viewModel.transform(input: output.eraseToAnyPublisher())
			.receive(on: DispatchQueue.main)
			.sink { [weak self] event in
				switch event {
				case .sizeSelected(size: let size):
					self?.sizeLabel.text = size.title
				case .engineSelected(engineId: let engineId):
					self?.engineLabel.text = engineId
				case .errorOccured(error: _):
					self?.infoAlert(message: LocaleStrings.error, title: LocaleStrings.errorTitle)
				case .toggleButton(isEnabled: let isEnabled):
					self?.generateButton.isEnabled = isEnabled
				case .imageGenerated(model: let model):
					self?.showGeneratedImage(response: model)
				case .cfgScaleSelected(cfgScale: let cfg):
					self?.cfgLabel.text = String(cfg)
				case .samplerSelected(sampler: let sampler):
					self?.samplerLabel.text = sampler.name.rawValue
				case .stepsSelected(steps: let steps):
					self?.stepsLabel.text = String(steps)
				}
			}
			.store(in: &cancellables)
	}

	private func showGeneratedImage(response: TextToImageResponse) {
		let vc = GeneratedImageViewController()
		vc.configure(response: response)
		let nav = UINavigationController(rootViewController: vc)
		nav.modalPresentationStyle = .fullScreen

		if let sheet = nav.sheetPresentationController {
			sheet.detents = [.large()]
			sheet.prefersScrollingExpandsWhenScrolledToEdge = false
			sheet.prefersGrabberVisible = true
			sheet.preferredCornerRadius = 10
		}

		present(nav, animated: true)
	}
}

// MARK: Handlers

extension HomePageViewController {
	@objc func selectSize(_ sender: UITapGestureRecognizer? = nil) {
		let vc = SizeSelectionListViewController()
		vc.output = self
		let nav = UINavigationController(rootViewController: vc)
		nav.modalPresentationStyle = .pageSheet

		if let sheet = nav.sheetPresentationController {
			sheet.detents = [.medium()]
			sheet.prefersScrollingExpandsWhenScrolledToEdge = false
			sheet.prefersGrabberVisible = true
			sheet.preferredCornerRadius = 10
			sheet.selectedDetentIdentifier = .medium
		}

		present(nav, animated: true)
	}

	@objc func selectEngine(_ sender: UITapGestureRecognizer? = nil) {
		let vc = EngineSelectionListViewController()
		vc.output = self
		let nav = UINavigationController(rootViewController: vc)
		nav.modalPresentationStyle = .pageSheet

		if let sheet = nav.sheetPresentationController {
			sheet.detents = [.medium()]
			sheet.prefersScrollingExpandsWhenScrolledToEdge = false
			sheet.prefersGrabberVisible = true
			sheet.preferredCornerRadius = 10
		}

		present(nav, animated: true)
	}

	@objc func selectCFG(_ sender: UITapGestureRecognizer? = nil) {
		let vc = CFGScaleViewController()
		vc.output = self
		let nav = UINavigationController(rootViewController: vc)
		nav.modalPresentationStyle = .pageSheet
		nav.preferredContentSize = CGSize(width: Constants.screenWidth, height: Constants.screenHeight * 0.2)
		if let sheet = nav.sheetPresentationController {
			sheet.detents = [
				.custom(resolver: { _ in
					Constants.screenHeight * 0.25
				})
			]
			sheet.prefersScrollingExpandsWhenScrolledToEdge = false
			sheet.prefersGrabberVisible = true
			sheet.preferredCornerRadius = 10
		}

		present(nav, animated: true)
	}

	@objc func selectSampler(_ sender: UITapGestureRecognizer? = nil) {
		let vc = SamplerViewController()
		vc.output = self
		let nav = UINavigationController(rootViewController: vc)
		nav.modalPresentationStyle = .pageSheet

		if let sheet = nav.sheetPresentationController {
			sheet.detents = [.large()]
			sheet.prefersScrollingExpandsWhenScrolledToEdge = false
			sheet.prefersGrabberVisible = true
			sheet.preferredCornerRadius = 10
			sheet.selectedDetentIdentifier = .medium
		}

		present(nav, animated: true)
	}

	@objc func selectSteps(_ sender: UITapGestureRecognizer? = nil) {
		let vc = StepsViewController()
		vc.output = self
		let nav = UINavigationController(rootViewController: vc)
		nav.modalPresentationStyle = .pageSheet
		nav.preferredContentSize = CGSize(width: Constants.screenWidth, height: Constants.screenHeight * 0.2)
		if let sheet = nav.sheetPresentationController {
			sheet.detents = [
				.custom(resolver: { _ in
					Constants.screenHeight * 0.25
				})
			]
			sheet.prefersScrollingExpandsWhenScrolledToEdge = false
			sheet.prefersGrabberVisible = true
			sheet.preferredCornerRadius = 10
		}

		present(nav, animated: true)
	}
}

// MARK: Delegates

extension HomePageViewController: UITextViewDelegate {
	private func setupTextView() {
		textView.delegate = self
		textView.text = LocaleStrings.prompt
		textView.textColor = Colors.textColor.color.withAlphaComponent(0.5)
	}

	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.text == LocaleStrings.prompt {
			textView.text = ""
			textView.textColor = Colors.textColor.color
		}
	}

	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.isEmpty {
			textView.text = LocaleStrings.prompt
			textView.textColor = Colors.textColor.color.withAlphaComponent(0.5)
		}
	}

	func textViewDidChange(_ textView: UITextView) {
		let size = CGSize(width: view.frame.width, height: .infinity)
		let estimatedSize = textView.sizeThatFits(size)
		textView.constraints.forEach { constraint in
			if constraint.firstAttribute == .height {
				constraint.constant = estimatedSize.height
			}
		}
		if textView.text != LocaleStrings.prompt {
			viewModel.prompt = textView.text
			output.send(.toggleButton)
		}
	}

	private func showPremium() {
		let vc = SubscriptionViewController()
		let nav = UINavigationController(rootViewController: vc)
		nav.modalPresentationStyle = .pageSheet

		if let sheet = nav.sheetPresentationController {
			sheet.detents = [.large()]
			sheet.prefersScrollingExpandsWhenScrolledToEdge = false
			sheet.prefersGrabberVisible = true
			sheet.preferredCornerRadius = 10
		}

		present(nav, animated: true)
	}
}

extension HomePageViewController: SizeSelectionListViewOutput {
	func didSelectItem(_ size: Size) {
		output.send(.sizeSelected(size: size))
	}
}

extension HomePageViewController: EngineSelectionListViewOutput {
	func didSelectItem(_ engine: Engine) {
		output.send(.engineSelected(engineId: engine.id))
	}
}

extension HomePageViewController: SamplerViewOutput {
	func didSelectItem(_ sampler: SamplerModel) {
		output.send(.samplerSelected(sampler: sampler))
	}
}

extension HomePageViewController: StepsViewOutput {
	func didSelectSteps(_ steps: Int) {
		output.send(.stepsSelected(steps: steps))
	}
}

extension HomePageViewController: CFGScaleViewOutput {
	func didSelectCFG(_ cfg: Int) {
		output.send(.cfgScaleSelected(cfgScale: cfg))
	}
}
