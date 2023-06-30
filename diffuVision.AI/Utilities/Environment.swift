//
//  Environment.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 1.07.2023.
//

import Foundation

var ENV: ApiKeyable {
	return ConfigEnv()
}

protocol ApiKeyable {
	var API_KEY: String { get }
	var API_HOST: String { get }
}

class BaseEnv {
	enum Key: String {
		case API_KEY
		case API_HOST
	}

	let dict: NSDictionary

	init(resourceName: String) {
		guard let filePath = Bundle.main.path(forResource: resourceName, ofType: "plist"),
		      let plist = NSDictionary(contentsOfFile: filePath)
		else {
			fatalError("Couldn't find file '\(resourceName)' plist")
		}
		self.dict = plist
	}
}

class ConfigEnv: BaseEnv, ApiKeyable {
	init() {
		super.init(resourceName: "Config")
	}

	var API_KEY: String {
		dict.object(forKey: Key.API_KEY.rawValue) as? String ?? ""
	}

	var API_HOST: String {
		dict.object(forKey: Key.API_HOST.rawValue) as? String ?? ""
	}
}
