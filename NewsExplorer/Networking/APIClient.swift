//
//  APIClient.swift
//  NewsExplorer
//
//  Created by Md Mazharul Islam on 12/1/26.
//

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
            .tryMap { output -> Data in
                guard let http = output.response as? HTTPURLResponse else {
                    throw NetworkError.badResponse
                }
                let status = http.statusCode
                guard (200...299).contains(status) else {
                    throw NetworkError.fromHTTPStatus(status)
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> Error in
                if error is DecodingError {
                    return NetworkError.decodingFailed
                }
                if let net = error as? NetworkError {
                    return net
                }
                if let urlError = error as? URLError {
                    return NetworkError.from(urlError)
                }
                return NetworkError.unknown
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
