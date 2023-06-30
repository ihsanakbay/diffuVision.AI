//
//  GenericSelectionListTableViewCell.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import UIKit

class GenericSelectionListTableViewCell<T: Selectable>: UITableViewCell {
	static var reuseId: String {
		return String(describing: Self.self)
	}

	private let title = LabelFactory.build(font: UIFont.systemFont(ofSize: 16),
	                                       textColor: Colors.textColor.color,
	                                       textAlignment: .left)

	private let checkmark: UIImageView = {
		let iv = UIImageView()
		iv.contentMode = .scaleAspectFit
		iv.image = Icons.General.checkmark.image
		iv.tintColor = Colors.accentColor.color
		iv.isHidden = true
		return iv
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupLayout()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupLayout() {
		backgroundColor = Colors.secondaryBackgroundColor.color
		addSubview(title)
		addSubview(checkmark)
		title.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(20)
			make.top.equalToSuperview().offset(12)
			make.bottom.equalToSuperview().offset(-12)
			make.trailing.equalTo(checkmark.snp.leading).offset(-12)
		}

		checkmark.snp.makeConstraints { make in
			make.height.width.equalTo(24)
			make.trailing.equalToSuperview().offset(-20)
			make.centerY.equalToSuperview()
		}
	}

	func configure(item: T, isSelected: Bool = false) {
		title.text = item.title
		checkmark.isHidden = !isSelected
	}
}
