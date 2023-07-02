//
//  GradientView.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 2.07.2023.
//

import UIKit

class GradientView: UIView {
	let startColor = Colors.backgroundColor.color
	let endColor = Colors.secondaryBackgroundColor.color
	let gradientLayer = CAGradientLayer()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLayout()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupLayout()
	}
	
	private func setupLayout() {
		gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
//		gradientLayer.type = .
		gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
		gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
		layer.addSublayer(gradientLayer)
	}
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		
		if gradientLayer.frame != bounds {
			gradientLayer.frame = bounds
		}
	}
}
