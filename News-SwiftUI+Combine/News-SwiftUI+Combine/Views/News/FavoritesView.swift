//
//  FavoritesView.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 25.05.25.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var viewModel: NewsViewModel
    @State private var safariURL: IdentifiableURL?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Group {
            if viewModel.getFavorites().isEmpty {
                EmptyStateView(type: .noFavorites, action: nil)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.getFavorites()) { article in
                            ArticleRow(
                                article: article,
                                isFavorite: true,
                                isBlocked: viewModel.isBlocked(article),
                                favoriteAction: { viewModel.toggleFavorite(article) },
                                blockAction: { viewModel.showBlockConfirmation(for: article) },
                                tapAction: { safariURL = IdentifiableURL(url: URL(string: article.webUrl)!) }
                            )
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
        }
        .navigationTitle("Favorites")
        .sheet(item: $viewModel.activeModal) { modal in
            switch modal {
            case .blockConfirmation(let article):
                BlockConfirmationView(article: article) {
                    viewModel.confirmBlock(article)
                }
            case .unblockConfirmation(let article):
                UnblockConfirmationView(article: article) {
                    viewModel.confirmUnblock(article)
                }
            default:
                EmptyView()
            }
        }
        .fullScreenCover(item: $safariURL) { SafariView(url: $0.url) }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(NewsViewModel.preview)
    }
}
