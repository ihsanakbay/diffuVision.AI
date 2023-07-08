//
//  GeneratedImageViewController.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 1.07.2023.
//

import SnapKit
import UIKit

class GeneratedImageViewController: UIViewController {
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
		guard let image = self.imageView.image else { return }
		UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
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
		self.shareTapped()
	}

	private var imageViewHeightConstraint: Constraint?

	override func viewDidLoad() {
		super.viewDidLoad()
		setupLayout()
	}

	private func setupLayout() {
		let rightBarButtonItem = UIBarButtonItem(image: Icons.General.xMarkCircle.image, style: .plain, target: self, action: #selector(dismissView))

		navigationItem.rightBarButtonItem = rightBarButtonItem
		navigationController?.navigationBar.tintColor = UIColor.white.withAlphaComponent(0.8)
		view.backgroundColor = Colors.backgroundColor.color

		view.addSubview(imageView)
		view.addSubview(shareButton)
		view.addSubview(saveButton)

		imageView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
			make.leading.equalTo(view.snp.leading).offset(16)
			make.trailing.equalTo(view.snp.trailing).offset(-16)
		}

		saveButton.snp.makeConstraints { make in
			make.top.equalTo(imageView.snp.bottom).offset(16)
			make.leading.equalTo(shareButton.snp.trailing).offset(16)
			make.trailing.equalTo(imageView.snp.trailing)
			make.height.equalTo(40)
			make.width.equalTo(120)
		}

		shareButton.snp.makeConstraints { make in
			make.centerY.equalTo(saveButton.snp.centerY)
			make.height.equalTo(40)
			make.width.equalTo(60)
		}
	}

	func configure(response: TextToImageResponse) {
		if !response.artifacts.isEmpty,
		   let base64 = response.artifacts[0].base64,
		   let imageData = Data(base64Encoded: base64),
		   let image = UIImage(data: imageData)
		{
			imageView.image = image
			resizeImageView()
		}
	}

	@objc private func dismissView() {
		dismiss(animated: true)
	}

	@objc private func imageSaved(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
		if let error = error {
			infoAlert(message: error.localizedDescription, title: LocaleStrings.errorTitle)
		} else {
			infoAlert(message: LocaleStrings.imageSaveSuccess)
		}
	}
}

extension GeneratedImageViewController {
	private func resizeImageView() {
		guard let image = imageView.image else { return }

		let aspectRatio = image.size.width / image.size.height

		imageView.snp.updateConstraints { make in
			make.height.equalTo(imageView.snp.width).dividedBy(aspectRatio)
		}

		view.layoutIfNeeded()
	}

	private func shareTapped() {
		guard let image = imageView.image else { return }
		let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
		present(activityController, animated: true)
	}
}
