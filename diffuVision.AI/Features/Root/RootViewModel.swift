	//
//  RootViewModel.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import Foundation

protocol RootViewModelOutput: AnyObject {
	func showLoginPage()
	func showMainPage()
}

final class RootViewModel {
//	private let loginStorageService: LoginStorageService
	weak var output: RootViewModelOutput?

//	init(loginStorageService: LoginStorageService) {
//		self.loginStorageService = loginStorageService
//	}

	func checkAuth() {
//		if let accessToken = loginStorageService.getUserAccessToken(),
//		   !accessToken.isEmpty
//		{
//		output?.showMainPage()
//		} else {
			output?.showLoginPage()
//		}
	}
}
