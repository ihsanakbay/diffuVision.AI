//
//  StepsViewController.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 8.07.2023.
//

import UIKit

protocol StepsViewOutput: AnyObject {
	func didSelectSteps(_ steps: Int)
}

class StepsViewController: UIViewController {
	private lazy var slider: UISlider = {
		let slider = UISlider()
		slider.minimumValue = 10
		slider.maximumValue = 90
		slider.value = 50
		slider.isContinuous = true
//		slider.tintColor = Colors.secondaryBackgroundColor.color
		slider.thumbTintColor = Colors.accentColor2.color
		slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
		return slider
	}()

	private let valueLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 18)
		return label
	}()

	private lazy var stackView = StackViewFactory.build(
		subviews: [valueLabel, slider],
		axis: .vertical,
		spacing: 8,
		alignment: .fill,
		distribution: .fillProportionally)

	weak var output: StepsViewOutput?

	override func viewDidLoad() {
		super.viewDidLoad()

		setupLayout()
	}

	private func setupLayout() {
		view.backgroundColor = Colors.backgroundColor.color
		title = "Steps"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocaleStrings.select, style: .done, target: self, action: #selector(doneTapped))

		view.addSubview(stackView)
		stackView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(20)
			make.centerX.centerY.equalToSuperview()
			make.trailing.equalToSuperview().offset(-20)
		}

		slider.value = round(slider.value)
		valueLabel.text = "Steps: \(Int(round(slider.value)))"
	}

	@objc func sliderValueChanged(_ sender: UISlider) {
		let value = Int(sender.value)
		valueLabel.text = "Steps: \(value)"
	}

	@objc private func doneTapped() {
		let value = Int(slider.value)
		output?.didSelectSteps(value)
		dismiss(animated: true)
	}
}
