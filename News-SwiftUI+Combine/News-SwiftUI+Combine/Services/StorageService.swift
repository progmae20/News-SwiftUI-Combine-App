//
//  StorageService.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 22.05.25.
//

import Foundation

protocol StorageServiceProtocol {
    func isFavorite(_ article: Article) -> Bool
    func isBlocked(_ article: Article) -> Bool
    func saveFavorite(_ article: Article)
    func removeFavorite(_ article: Article)
    func blockArticle(_ article: Article)
    func unblockArticle(_ article: Article)
    func getFavorites() -> [Article]
    func getBlocked() -> [Article]
}

class StorageService: StorageServiceProtocol {
    static let shared = StorageService()
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "favoritesArticles"
    private let blockedKey = "blockedArticles"
    
    func isFavorite(_ article: Article) -> Bool {
        return getFavorites().contains { $0.id == article.id }
    }
    
    func isBlocked(_ article: Article) -> Bool {
        return getBlocked().contains { $0.id == article.id }
    }
    
    func saveFavorite(_ article: Article) {
        var favorites = getFavorites()
        if !favorites.contains(where: { $0.id == article.id }) {
            favorites.append(article)
            save(favorites, forKey: favoritesKey)
        }
    }
    
    func removeFavorite(_ article: Article) {
        var favorites = getFavorites()
        favorites.removeAll { $0.id == article.id }
        save(favorites, forKey: favoritesKey)
    }
    
    func blockArticle(_ article: Article) {
        var blocked = getBlocked()
        if !blocked.contains(where: { $0.id == article.id }) {
            blocked.append(article)
            save(blocked, forKey: blockedKey)
        }
    }
    
    func unblockArticle(_ article: Article) {
        var blocked = getBlocked()
        blocked.removeAll { $0.id == article.id }
        save(blocked, forKey: blockedKey)
    }
    
    func getFavorites() -> [Article] {
        guard let data = userDefaults.data(forKey: favoritesKey),
              let favorites = try? JSONDecoder().decode([Article].self, from: data) else {
            return []
        }
        return favorites
    }
    
    func getBlocked() -> [Article] {
        guard let data = userDefaults.data(forKey: blockedKey),
              let blocked = try? JSONDecoder().decode([Article].self, from: data) else {
            return []
        }
        return blocked
    }
    
    private func save(_ articles: [Article], forKey key: String) {
        if let encoded = try? JSONEncoder().encode(articles) {
            userDefaults.set(encoded, forKey: key)
        }
    }
}
