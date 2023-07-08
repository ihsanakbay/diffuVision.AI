//
//  ApiRouter.swift
//  diffuVision
//
//  Created by İhsan Akbay on 4.06.2023.
//

import Foundation

class ApiRouter {
	struct GenerateImage: Request {
		typealias ReturnType = TextToImageResponse
		var path: String
		var method: HttpMethod = .post
		var body: [String: Any]?
		init(body: APIParameters.TextToImageRequest, engine: String) {
			self.body = body.asDictionary
			self.path = "/v1/generation/\(engine)/text-to-image"
		}
	}
}
