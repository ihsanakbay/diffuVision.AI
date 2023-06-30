//
//  ApiClient.swift
//  diffuVision
//
//  Created by İhsan Akbay on 4.06.2023.
//

import Combine
import Foundation

struct ApiClient {
	static var networkDispatcher: NetworkDispatcher = .init()

	/// Dispatches a Request and returns a publisher
	/// - Parameter request: Request to Dispatch
	/// - Returns: A publisher containing decoded data or an error
	static func dispatch<R: Request>(_ request: R) -> AnyPublisher<R.ReturnType, NetworkRequestError> {
		guard let urlRequest = request.asURLRequest(baseURL: APIConstants.basedURL) else {
			return Fail(outputType: R.ReturnType.self, failure: NetworkRequestError.badRequest)
				.eraseToAnyPublisher()
		}
		typealias RequestPublisher = AnyPublisher<R.ReturnType, NetworkRequestError>
		let requestPublisher: RequestPublisher = networkDispatcher.dispatch(request: urlRequest)
		return requestPublisher
			.eraseToAnyPublisher()
	}
}
