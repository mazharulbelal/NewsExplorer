//
//  NetworkError.swift
//  NewsExplorer
//
//  Created by Md Mazharul Islam on 12/1/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noInternet
    case timedOut
    case cancelled
    case badResponse
    case http(Int)
    case decodingFailed
    case transport          
    case unknown

    // Map URLError to higher-level cases
    static func from(_ urlError: URLError) -> NetworkError {
        switch urlError.code {
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
            return .noInternet
        case .timedOut:
            return .timedOut
        case .cancelled:
            return .cancelled
        default:
            return .transport
        }
    }

    static func fromHTTPStatus(_ status: Int) -> NetworkError {
        return .http(status)
    }

    var userMessage: String {
        switch self {
        case .invalidURL:
            return "We couldn’t make a valid request. Please try again."
        case .noInternet:
            return "You appear to be offline. Please check your internet connection."
        case .timedOut:
            return "The request timed out. Please try again."
        case .cancelled:
            return "The request was cancelled."
        case .badResponse:
            return "We received an invalid response from the server."
        case .http(let code):
            switch code {
            case 401: return "You’re not authorized. Please sign in again."
            case 403: return "You don’t have permission to perform this action."
            case 404: return "The requested resource was not found."
            case 429: return "Too many requests. Please try again later."
            case 500...599: return "The server encountered an error. Please try again later."
            default: return "The server returned an error. Please try again."
            }
        case .decodingFailed:
            return "We couldn’t process the server response."
        case .transport:
            return "A network error occurred. Please try again."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
