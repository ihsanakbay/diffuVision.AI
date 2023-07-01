//
//  GeneratedImageViewController.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 1.07.2023.
//

import UIKit

class GeneratedImageViewController: UIViewController {

	private let scrollView = UIScrollView()

	private lazy var generatedImageView = GeneratedImageView()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupLayout()
	}

	private func setupLayout() {
		let rightBarButtonItem = UIBarButtonItem(image: Icons.General.xMarkCircle.image, style: .plain, target: self, action: #selector(dismissView))
		
		navigationItem.rightBarButtonItem = rightBarButtonItem
		navigationController?.navigationBar.tintColor = UIColor.white.withAlphaComponent(0.8)
		view.backgroundColor = Colors.backgroundColor.color
		view.addSubview(scrollView)
		scrollView.addSubview(generatedImageView)
		scrollView.snp.makeConstraints { make in
			make.top.equalTo(view.snp.top)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.bottom.equalTo(view.snp.bottom)
		}

		generatedImageView.snp.makeConstraints { make in
			make.top.equalTo(scrollView.snp.top)
			make.leading.equalTo(scrollView.snp.leading)
			make.bottom.equalTo(scrollView.snp.bottom)
			make.trailing.equalTo(scrollView.snp.trailing)
			make.height.equalTo(scrollView.snp.height)
			make.width.equalTo(scrollView.snp.width)
		}

//		scrollView.contentSize = generatedImageView.frame.size

		generatedImageView.configure(model: GeneratedImageItemModel(promtMessage: "ldkfkmfknfmfkgfdknknfgdn kndgfkngfknf dknfghnk nkfghnk kmndgfnkmhfgnm dfgnkmnfgmknfmknfgmnfghmnfhgmn hgfmfhgmnhfgmkn  nikfd"))
	}

	@objc private func dismissView() {
		dismiss(animated: true)
	}
}
