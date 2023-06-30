//
//  SettingsItemView.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 30.06.2023.
//

import UIKit

class SettingsItemView: UIView {
	private let title = LabelFactory.build(font: UIFont.systemFont(ofSize: 16),
	                                       textColor: Colors.textColor.color,
	                                       textAlignment: .left)
	private let iconView: UIView = {
		let view = UIView()
		view.backgroundColor = Colors.accentColor.color
		view.layer.cornerRadius = 10
		return view
	}()

	private let icon: UIImageView = {
		let iv = UIImageView()
		iv.tintColor = Colors.textColor.color
		return iv
	}()

	private lazy var stackView = StackViewFactory.build(
		subviews: [iconView, title],
		axis: .horizontal,
		spacing: 16,
		alignment: .leading,
		distribution: .fillProportionally)

	private var action: (() -> Void)?

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLayout()
		setupTapGesture()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupTapGesture() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(actionHandler))
		addGestureRecognizer(tap)
	}

	@objc private func actionHandler() {
		action?()
	}

	private func setupLayout() {
		backgroundColor = Colors.secondaryBackgroundColor.color
		layer.cornerRadius = 10
		iconView.addSubview(icon)
		addSubview(stackView)
		stackView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(8)
			make.leading.equalToSuperview().offset(8)
			make.trailing.equalToSuperview().offset(-8)
			make.bottom.equalToSuperview().offset(-8)
		}

		iconView.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.leading.equalToSuperview()
			make.bottom.equalToSuperview()
			make.height.width.equalTo(30)
		}

		icon.snp.makeConstraints { make in
			make.height.width.equalTo(20)
			make.centerY.centerX.equalToSuperview()
		}
		title.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.leading.equalTo(iconView.snp.trailing).offset(16)
		}
	}

	func configure(iconName: String, title: String, titleColor: UIColor? = nil, action: (() -> Void)? = nil) {
		icon.image = UIImage(systemName: iconName)
		self.title.text = title

		if let color = titleColor {
			self.title.textColor = color
		}

		self.action = action
	}
}
