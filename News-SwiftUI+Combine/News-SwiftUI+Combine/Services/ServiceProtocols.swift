//
//  ServiceProtocols.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 27.05.25.
//
//

// Services/ServiceProtocols.swift
import Foundation
import Combine

protocol NewsServiceProtocol {
    func fetchNews(page: Int, pageSize: Int) -> AnyPublisher<[Article], Error>
}

protocol NavigationServiceProtocol {
    func fetchNavigationBlocks() -> AnyPublisher<[NavigationBlock], Error>
}

//protocol StorageServiceProtocol {
//    func isFavorite(_ article: Article) -> Bool
//    func isBlocked(_ article: Article) -> Bool
//    func saveFavorite(_ article: Article)
//    func removeFavorite(_ article: Article)
//    func blockArticle(_ article: Article)
//    func unblockArticle(_ article: Article)
//    func getFavorites() -> [Article]
//    func getBlocked() -> [Article]
//}
