//
//  NewsService.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 25.05.25.
//

import Foundation
import Combine

class NewsService: NewsServiceProtocol {
    private let baseURL = "https://us-central1-server-side-functions.cloudfunctions.net/guardian"
    private let authHeader = "anastasia-martynova"
    
    func fetchNews(page: Int, pageSize: Int) -> AnyPublisher<[Article], Error> {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "page-size", value: String(pageSize))
        ]
        
        var request = URLRequest(url: components.url!)
        request.addValue(authHeader, forHTTPHeaderField: "authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NewsViewModel.NewsError.invalidResponse
                }
                
                switch httpResponse.statusCode {
                case 401:
                    throw NewsViewModel.NewsError.unauthorized
                case 400...499:
                    throw NewsViewModel.NewsError.clientError(httpResponse.statusCode)
                case 500...599:
                    throw NewsViewModel.NewsError.serverError(httpResponse.statusCode)
                case 200...299:
                    return data
                default:
                    throw NewsViewModel.NewsError.unknown
                }
            }
            .mapError { error -> Error in
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet, .networkConnectionLost:
                        return NewsViewModel.NewsError.noInternetConnection
                    case .timedOut:
                        return NewsViewModel.NewsError.timeout
                    default:
                        return NewsViewModel.NewsError.networkError(urlError)
                    }
                }
                return error
            }
            .decode(type: GuardianResponse.self, decoder: JSONDecoder())
            .map { $0.response.results }
            .eraseToAnyPublisher()
    }
    
    private struct GuardianResponse: Codable {
        let response: Response
        
        struct Response: Codable {
            let status: String
            let results: [Article]
        }
    }
}
