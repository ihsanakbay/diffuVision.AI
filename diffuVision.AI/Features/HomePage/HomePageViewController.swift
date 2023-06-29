//
//  HomePageViewController.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import UIKit

class HomePageViewController: UIViewController {
	private let viewModel: HomePageViewModel

	init(viewModel: HomePageViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		viewModel.output = self
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.input?.viewDidLoad()
		view.backgroundColor = Colors.backgroundColor.color
	}
}

extension HomePageViewController: HomePageViewOutput {
	func refresh() {
		#warning("Refrsh data or ui in here")
	}
}
