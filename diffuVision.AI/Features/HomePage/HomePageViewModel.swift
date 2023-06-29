//
//  HomePageViewModel.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import Foundation

protocol HomePageViewInput: AnyObject {
	func viewDidLoad()
}

protocol HomePageViewOutput: AnyObject {
	func refresh()
}

final class HomePageViewModel {
	weak var input: HomePageViewInput?
	weak var output: HomePageViewOutput?

	init() {
		input = self
	}
}

extension HomePageViewModel: HomePageViewInput {
	func viewDidLoad() {
		#warning("Run some logic")
		output?.refresh()
	}
	
	
}
