//
//  SamplerModel.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 8.07.2023.
//

import Foundation

struct SamplerModel: Selectable {
	var name: Sampler
	var title: String? {
		return name.rawValue
	}
}

extension SamplerModel {
	static let samplers: [SamplerModel] = [
		SamplerModel(name: .AUTO),
		SamplerModel(name: .DDIM),
		SamplerModel(name: .DDPM),
		SamplerModel(name: .K_DPMPP_2M),
		SamplerModel(name: .K_DPMPP_2S_ANCESTRAL),
		SamplerModel(name: .K_DPM_2),
		SamplerModel(name: .K_DPM_2_ANCESTRAL),
		SamplerModel(name: .K_EULER),
		SamplerModel(name: .K_EULER_ANCESTRAL),
		SamplerModel(name: .K_HEUN),
		SamplerModel(name: .K_LMS)
	]
}
