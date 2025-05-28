//
//  ArticleRow.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 22.05.25.
//

import SwiftUI

struct ArticleRow: View {
    let article: Article
    let isFavorite: Bool
    let isBlocked: Bool
    let favoriteAction: () -> Void
    let blockAction: () -> Void
    let tapAction: () -> Void
    
    var body: some View {
        Button(action: tapAction) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.webTitle)
                        .font(.headline)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                    
                    Text("\(article.sectionName) • \(article.formattedDate)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button(action: favoriteAction) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .gray)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: blockAction) {
                        Image(systemName: isBlocked ? "slash.circle.fill" : "slash.circle")
                            .foregroundColor(isBlocked ? .red : .gray)
                    }
                    .buttonStyle(.plain)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}
