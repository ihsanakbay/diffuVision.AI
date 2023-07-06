//
//  SubscriptionTableViewCell.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 3.07.2023.
//

import StoreKit
import UIKit

class SubscriptionTableViewCell: UITableViewCell {
	static var reuseId: String {
		return String(describing: Self.self)
	}

	private let titleLabel: UILabel = {
		let label = LabelFactory.build(
			font: UIFont.systemFont(ofSize: 16),
			textColor: Colors.textColor.color,
			textAlignment: .left,
			numOfLines: 2)
		return label
	}()

	private let priceLabel: UILabel = {
		let label = LabelFactory.build(
			font: UIFont.systemFont(ofSize: 20, weight: .semibold),
			textColor: Colors.textColor.color,
			textAlignment: .right)
		return label
	}()

	private lazy var stackView = StackViewFactory.build(
		subviews: [titleLabel, priceLabel],
		axis: .horizontal,
		spacing: 16,
		alignment: .fill,
		distribution: .fillProportionally)

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.setupLayout()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupLayout() {
		backgroundColor = Colors.secondaryBackgroundColor.color
		addSubview(self.stackView)
		self.stackView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(20)
			make.top.equalToSuperview().offset(20)
			make.bottom.equalToSuperview().offset(-20)
			make.trailing.equalToSuperview().offset(-20)
		}
	}

	func configure(model: Product) {
		self.titleLabel.text = model.displayName
		self.priceLabel.text = model.displayPrice
	}
}
