//
//  ApiParameters.swift
//  diffuVision
//
//  Created by İhsan Akbay on 4.06.2023.
//

import Foundation

enum APIParameters {
	struct TextToImageRequest: Codable {
		var cfgScale: Int
		var clipGuidancePreset: String
		var height: Int
		var width: Int
		var samples: Int
		var steps: Int
		var stylePreset: String?
		var textPrompts: [TextPrompt]

		enum CodingKeys: String, CodingKey {
			case cfgScale = "cfg_scale"
			case clipGuidancePreset = "clip_guidance_preset"
			case height
			case width
			case samples
			case steps
			case stylePreset = "style_preset"
			case textPrompts = "text_prompts"
		}

		init() {
			self.cfgScale = DefaultValues.cfgScale
			self.clipGuidancePreset = ClipGuidancePreset.NONE.rawValue
			self.height = DefaultValues.height
			self.width = DefaultValues.width
			self.samples = DefaultValues.samples
			self.steps = DefaultValues.steps
			self.textPrompts = []
		}
	}

	struct TextPrompt: Codable {
		var text: String

		enum CodingKeys: String, CodingKey {
			case text
		}
	}
}
