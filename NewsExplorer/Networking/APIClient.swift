//
//  APIClient.swift
//  NewsExplorer
//
//  Created by Md Mazharul Islam on 12/1/26.
//

import Combine
import Foundation

import Combine
import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, Error>
}

final class APIClient: APIClientProtocol {

    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, Error> {

        var components = URLComponents(string: AppEnvironment.baseURL)
        components?.path += endpoint.path
        components?.queryItems = endpoint.queryItems

        guard let url = components?.url else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
