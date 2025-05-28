//
//  MockNewsService.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 29.05.25.
//

import Foundation
import Combine
@testable import News_SwiftUI_Combine

struct MockNewsService: NewsServiceProtocol {
    let result: Result<[Article], Error>
    
    init(result: Result<[Article], Error> = .success([])) {
        self.result = result
    }
    
    func fetchNews(page: Int, pageSize: Int) -> AnyPublisher<[Article], Error> {
        result.publisher
            .eraseToAnyPublisher()
    }
}

struct MockNavigationService: NavigationServiceProtocol {
    let result: Result<[NavigationBlock], Error>
    
    init(result: Result<[NavigationBlock], Error> = .success([])) {
        self.result = result
    }
    
    func fetchNavigationBlocks() -> AnyPublisher<[NavigationBlock], Error> {
        result.publisher
            .eraseToAnyPublisher()
    }
}
