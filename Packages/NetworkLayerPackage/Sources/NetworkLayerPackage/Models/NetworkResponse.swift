//
//  NetworkResponse.swift
//  NetworkLayer
//
//  Created by Kirill Leonov 
//

import Foundation

public struct NetworkResponse {
	let result: Result<Data?, HTTPNetworkServiceError>
	
	public init(data: Data? = nil, urlResponse: URLResponse? = nil, error: Error? = nil) {
		guard let urlResponse = urlResponse as? HTTPURLResponse else {
			self.result = .failure(.invalidResponse(urlResponse))
			return
		}
		guard let status = ResponseStatus(rawValue: urlResponse.statusCode), status.isSuccess else {
			self.result = .failure(.invalidStatusCode(urlResponse.statusCode, data))
			return
		}
		if let error = error {
			self.result = .failure(.networkError(error))
		} else {
			self.result = .success(data)
		}
	}
}
