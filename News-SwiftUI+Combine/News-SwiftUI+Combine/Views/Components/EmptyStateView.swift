//
//  EmptyStateView.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 26.05.25.
//

import SwiftUI

struct EmptyStateView: View {
    enum EmptyStateType {
        case noInternet
        case serverError
        case noNews
        case noFavorites
        case noBlocked
        case noSearchResults
        
        var icon: String {
            switch self {
            case .noInternet: return "wifi.slash"
            case .serverError: return "exclamationmark.icloud"
            case .noNews: return "newspaper"
            case .noFavorites: return "heart.slash"
            case .noBlocked: return "slash.circle"
            case .noSearchResults: return "magnifyingglass"
            }
        }
        
        var title: String {
            switch self {
            case .noInternet: return "No Connection"
            case .serverError: return "Server Error"
            case .noNews: return "No News Found"
            case .noFavorites: return "No Favorites"
            case .noBlocked: return "No Blocked Items"
            case .noSearchResults: return "No Results"
            }
        }
        
        var message: String {
            switch self {
            case .noInternet: return "Please check your internet connection"
            case .serverError: return "Failed to load data from server"
            case .noNews: return "Couldn't find any news articles"
            case .noFavorites: return "You haven't added any favorites yet"
            case .noBlocked: return "You haven't blocked any news sources"
            case .noSearchResults: return "Try different search terms"
            }
        }
    }
    
    let type: EmptyStateType
    let action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: type.icon)
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text(type.title)
                .font(.title2)
                .bold()
            
            Text(type.message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            if let action = action {
                Button("Try Again", action: action)
                    .buttonStyle(.bordered)
                    .padding(.top)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
