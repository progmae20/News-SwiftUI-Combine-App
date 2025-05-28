//
//  NavigationService.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 22.05.25.
//

import Foundation
import Combine

struct NavigationResponse: Codable {
    let results: [NavigationBlock]
}

class NavigationService: NavigationServiceProtocol {
    private let baseURL = "https://us-central1-server-side-functions.cloudfunctions.net/navigation"
    private let authHeader = "anastasia-martynova"
    
    func fetchNavigationBlocks() -> AnyPublisher<[NavigationBlock], Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.addValue(authHeader, forHTTPHeaderField: "authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: NavigationResponse.self, decoder: JSONDecoder())
            .map { (response: NavigationResponse) -> [NavigationBlock] in
                return response.results
            }
            .eraseToAnyPublisher()
    }
}
