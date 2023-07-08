//
//  CFGScaleViewController.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 8.07.2023.
//

import UIKit

protocol CFGScaleViewOutput: AnyObject {
	func didSelectCFG(_ cfg: Int)
}

class CFGScaleViewController: UIViewController {
	private lazy var slider: UISlider = {
		let slider = UISlider()
		slider.minimumValue = 0
		slider.maximumValue = 35
		slider.value = 7
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

	weak var output: CFGScaleViewOutput?

	override func viewDidLoad() {
		super.viewDidLoad()

		setupLayout()
	}

	private func setupLayout() {
		view.backgroundColor = Colors.backgroundColor.color
		title = "CFG Scale"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocaleStrings.select, style: .done, target: self, action: #selector(doneTapped))

		view.addSubview(stackView)
		stackView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(20)
			make.centerX.centerY.equalToSuperview()
			make.trailing.equalToSuperview().offset(-20)
		}

		slider.value = round(slider.value)
		valueLabel.text = "CFG Scale: \(Int(round(slider.value)))"
	}

	@objc func sliderValueChanged(_ sender: UISlider) {
		let value = Int(sender.value)
		valueLabel.text = "CFG Scale: \(value)"
	}

	@objc private func doneTapped() {
		let value = Int(slider.value)
		output?.didSelectCFG(value)
		dismiss(animated: true)
	}
}
