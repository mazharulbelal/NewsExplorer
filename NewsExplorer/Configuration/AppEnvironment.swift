//
//  AppEnvironment.swift
//  NewsExplorer
//
//  Created by Md Mazharul Islam on 12/1/26.
//


import Foundation

enum AppConfiguration: String {
    case dev
    case qa
    case prod

    var newsBaseURL: String {
        switch self {
        case .dev:  return "https://dev.example.com/newsapi"
        case .qa:   return "https://qa.example.com/newsapi"
        case .prod: return "https://newsapi.org/v2"
        }
    }

    var newsApiKey: String { "81ddf76c6cc14546bd547ccaa9a9b03f" }
}

enum AppEnvironment {
    static let current: AppConfiguration =  .prod
    static var baseURL: String { current.newsBaseURL }
    static var apiKey: String { current.newsApiKey }
}
