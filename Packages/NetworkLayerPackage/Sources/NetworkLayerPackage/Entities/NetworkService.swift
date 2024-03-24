//
//  NetworkService.swift
//  NetworkLayer
//
//  Created by Kirill Leonov 
//

import Foundation

public protocol INetworkService {
	func perform<T: Codable>(
		_ request: INetworkRequest,
		token: Token?,
		completion: @escaping (Result<T, HTTPNetworkServiceError>) -> Void
	)

	func perform(
		_ request: INetworkRequest,
		token: Token?,
		completion: @escaping (Result<Data?, HTTPNetworkServiceError>) -> Void
	)

	func perform(urlRequest: URLRequest, completion: @escaping (Result<Data?, HTTPNetworkServiceError>) -> Void)
}

public final class NetworkService: INetworkService {
	private let session: URLSession
	private let requestBuilder: URLRequestBuilder
	
	public init(session: URLSession, baseUrl: URL) {
		self.session = session
		requestBuilder = URLRequestBuilder(baseUrl: baseUrl)
	}
	
	public func perform<T: Codable>(
		_ request: INetworkRequest,
		token: Token?,
		completion: @escaping (Result<T, HTTPNetworkServiceError>) -> Void
	) {
		let urlRequest = requestBuilder.build(forRequest: request, token: token)
		perform(urlRequest: urlRequest) { result in
			switch result {
			case let .success(data):
				guard let data = data else {
					completion(.failure(.noData))
					return
				}
				do {
					let object = try JSONDecoder().decode(T.self, from: data)
					completion(.success(object))
				} catch {
					completion(.failure(.failedToDecodeResponse(error)))
				}
			case let .failure(error):
				completion(.failure(error))
			}
		}
	}
	
	public func perform(
		_ request: INetworkRequest,
		token: Token?,
		completion: @escaping (Result<Data?, HTTPNetworkServiceError>) -> Void
	) {
		let urlRequest = requestBuilder.build(forRequest: request, token: token)
		perform(urlRequest: urlRequest, completion: completion)
	}
	
	public func perform(urlRequest: URLRequest, completion: @escaping (Result<Data?, HTTPNetworkServiceError>) -> Void) {
		let task = session.dataTask(with: urlRequest) { data, urlResponse, error in
			let networkResponse = NetworkResponse(data: data, urlResponse: urlResponse, error: error)
			completion(networkResponse.result)
		}
		task.resume()
	}
}
