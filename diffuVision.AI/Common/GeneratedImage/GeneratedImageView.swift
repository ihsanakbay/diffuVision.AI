//
//  GeneratedImageView.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 1.07.2023.
//

import Kingfisher
import SnapKit
import UIKit

class GeneratedImageView: UIView {
	private lazy var copyTextButton: UIButton = {
		let button = UIButton(type: .system)
		button.configuration = .plain()
		button.configuration?.baseForegroundColor = button.isHighlighted ? Colors.textColor.color : Colors.accentColor.color
		button.configuration?.image = Icons.General.copyFill.image
		button.contentHorizontalAlignment = .center
		button.addTarget(self, action: #selector(copyTapped), for: .touchUpInside)
		button.configuration?.buttonSize = .mini
		return button
	}()
	
	private lazy var promptLabel: UITextView = {
		let textView = UITextView()
		textView.isScrollEnabled = false
		textView.layer.cornerRadius = 10
		textView.backgroundColor = Colors.secondaryBackgroundColor.color
		textView.textColor = Colors.textColor.color
		textView.font = UIFont.systemFont(ofSize: 14)
		textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
		textView.textAlignment = .left
		textView.isUserInteractionEnabled = false
		return textView
	}()
	
	private let imageView: UIImageView = {
		let iv = UIImageView()
		iv.contentMode = .scaleAspectFit
		iv.layer.cornerRadius = 10
		iv.clipsToBounds = true
		iv.frame = CGRect(x: 0, y: 0, width: 512, height: 512)
		return iv
	}()
	
	private lazy var saveButton = ButtonFactory.build(
		text: LocaleStrings.save,
		buttonStyle: .borderedProminent(),
		foregroundColor: Colors.textColor.color,
		backgroundColor: Colors.accentColor.color,
		image: Icons.General.download.image,
		imagePadding: 16,
		imagePlacement: .leading,
		cornerStyle: .large,
		contentAlignment: .center)
	{
		#warning("save action")
	}

	private lazy var shareButton = ButtonFactory.build(
		text: "",
		buttonStyle: .borderedProminent(),
		foregroundColor: Colors.textColor.color,
		backgroundColor: Colors.accentColor.color,
		image: Icons.General.share.image,
		imagePadding: 16,
		imagePlacement: .leading,
		cornerStyle: .large,
		contentAlignment: .center)
	{
		#warning("share action")
	}

	private var imageViewHeightConstraint: Constraint?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLayout()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupLayout() {
		backgroundColor = .clear
		addSubview(promptLabel)
		addSubview(copyTextButton)
		addSubview(imageView)
		addSubview(shareButton)
		addSubview(saveButton)
	
		promptLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(16)
			make.leading.equalToSuperview().offset(16)
			make.trailing.equalToSuperview().offset(-16)
			make.bottom.equalTo(imageView.snp.top).offset(-16)
		}
		
		copyTextButton.snp.makeConstraints { make in
			make.trailing.equalTo(promptLabel.snp.trailing).offset(8)
			make.bottom.equalTo(promptLabel.snp.bottom).offset(8)
		}
		
		imageView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(16)
			make.trailing.equalToSuperview().offset(-16)
		}
		
		saveButton.snp.makeConstraints { make in
			make.top.equalTo(imageView.snp.bottom).offset(16)
			make.leading.equalTo(shareButton.snp.trailing).offset(16)
			make.trailing.equalToSuperview().offset(-16)
			make.height.equalTo(40)
			make.width.equalTo(120)
		}
		shareButton.snp.makeConstraints { make in
			make.centerY.equalTo(saveButton.snp.centerY)
			make.height.equalTo(40)
			make.width.equalTo(60)
		}
	}
	
	func configure(model: GeneratedImageItemModel) {
		promptLabel.text = model.promtMessage
		let url = URL(string: "https://r2.stablediffusionweb.com/images/stable-diffusion-demo-2.webp")
		
		imageView.kf.indicatorType = .activity
		imageView.kf.setImage(with: url) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let value):
				self.imageView.image = value.image
				self.resizeImageView()
			case .failure(let error):
				print("Image download failed with error: \(error)")
			}
		}
	
//		if let response = model.response,
//		   !response.artifacts.isEmpty,
//		   let base64 = response.artifacts[0].base64
//		{
//			let imageData = "data:image/png;base64,\(base64)"
//			let url = URL(string: imageData)
//			imageView.kf.indicatorType = .activity
//			imageView.kf.setImage(with: url)
//		}
	}
}

extension GeneratedImageView {
	private func resizeImageView() {
		guard let image = imageView.image else { return }
		let aspectRatio = image.size.width / image.size.height
		let newHeight = imageView.frame.width / aspectRatio
				
		if let constraint = imageViewHeightConstraint {
			constraint.update(offset: newHeight)
		} else {
			imageView.snp.makeConstraints { make in
				self.imageViewHeightConstraint = make.height.equalTo(newHeight).constraint
			}
		}
		layoutIfNeeded()
	}
	
	@objc private func copyTapped() {
		UIPasteboard.general.string = promptLabel.text
	}
}
