//
//  Constants.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import UIKit

let bundleID = Bundle.main.bundleIdentifier ?? "com.ihsanakbay.diffuVision-AI"

enum Constants {
	static let screenWidth = UIScreen.main.bounds.width
	static let screenHeight = UIScreen.main.bounds.height
	static let engineId = "stable-diffusion-512-v2-1"
	static let termsOfUseLink = "https://ihsanakbay.github.io/app-docs/diffuVision-AI-terms-of-use.html"
	static let privacyPolicyLink = "https://ihsanakbay.github.io/app-docs/diffuVision-AI-privacy.html"
}

class SelectedItem {
	static let shared = SelectedItem()
	var size: Size = .sizes[1]
	var engine: Engine = .engines[2]
	var sampler: SamplerModel = .init(name: .AUTO)
	private init() {}
}

enum DefaultValues {
	static let height = 512
	static let width = 512
	static let cfgScale = 7
	static let samples = 1
	static let steps = 50
}

enum Sampler: String, Equatable, Hashable {
	case AUTO
	case DDIM
	case DDPM
	case K_DPMPP_2M
	case K_DPMPP_2S_ANCESTRAL
	case K_DPM_2
	case K_DPM_2_ANCESTRAL
	case K_EULER
	case K_EULER_ANCESTRAL
	case K_HEUN
	case K_LMS
}
