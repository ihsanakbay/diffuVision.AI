//
//  ApiConstants.swift
//  diffuVision
//
//  Created by İhsan Akbay on 4.06.2023.
//

import Foundation

final class APIConstants {
	static var basedURL: String = ENV.API_HOST
}

enum HTTPHeaderField: String {
	case authentication = "Authentication"
	case contentType = "Content-Type"
	case acceptType = "Accept"
	case acceptEncoding = "Accept-Encoding"
	case authorization = "Authorization"
	case acceptLanguage = "Accept-Language"
	case userAgent = "User-Agent"
}

enum ContentType: String {
	case json = "application/json"
	case xwwwformurlencoded = "application/x-www-form-urlencoded"
}

enum HttpMethod: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case delete = "DELETE"
}
