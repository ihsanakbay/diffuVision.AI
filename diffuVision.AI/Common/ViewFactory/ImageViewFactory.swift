//
//  ImageViewFactory.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import UIKit

enum ImageViewFactory {
	static func build(
		contentMode: UIView.ContentMode = .scaleAspectFill,
		backgroundColor: UIColor = .systemCyan,
		cornerRadius: CGFloat = 10
	) -> UIImageView {
		let imageView = UIImageView()
		imageView.contentMode = contentMode
		imageView.clipsToBounds = true
		imageView.backgroundColor = backgroundColor
		imageView.layer.cornerRadius = cornerRadius

		imageView.layer.shadowColor = UIColor.white.cgColor
		imageView.layer.shadowOpacity = 0.5
		imageView.layer.shadowOffset = CGSize(width: 2, height: 2)
		imageView.layer.shadowRadius = 10

		return imageView
	}
}
