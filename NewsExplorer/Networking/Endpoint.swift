//
//  Endpoint.swift
//  NewsExplorer
//
//  Created by Md Mazharul Islam on 12/1/26.
//
import Foundation

protocol Endpoint {
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}
enum NewsEndpoint: Endpoint {
    case appleNews

    var path: String { "/everything" }

    var queryItems: [URLQueryItem] {
        [
            .init(name: "q", value: "apple"),
            .init(name: "from", value: "2026-01-10"),
            .init(name: "sortBy", value: "publishedAt"),
            .init(name: "apiKey", value: AppEnvironment.apiKey)
        ]
    }
}
