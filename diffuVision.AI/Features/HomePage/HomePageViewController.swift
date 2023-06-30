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
		#warning("dont forget")
//		viewModel.generateImage()
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
		
		view.addSubview(emptyLabel)
		emptyLabel.snp.makeConstraints { make in
			make.top.equalTo(engineView.snp.bottom).offset(40)
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
				}
			}
			.store(in: &cancellables)
	}

	@objc func selectSize(_ sender: UITapGestureRecognizer? = nil) {
		let vc = SizeSelectionListViewController()
		vc.output = self
		let nav = UINavigationController(rootViewController: vc)
		nav.modalPresentationStyle = .pageSheet
		nav.view.backgroundColor = .blue

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
		vc.engines = viewModel.engines
		let nav = UINavigationController(rootViewController: vc)
		nav.modalPresentationStyle = .pageSheet
		nav.view.backgroundColor = .blue

		if let sheet = nav.sheetPresentationController {
			sheet.detents = [.large()]
			sheet.prefersScrollingExpandsWhenScrolledToEdge = false
			sheet.prefersGrabberVisible = true
			sheet.preferredCornerRadius = 10
		}

		present(nav, animated: true)
	}
}

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
