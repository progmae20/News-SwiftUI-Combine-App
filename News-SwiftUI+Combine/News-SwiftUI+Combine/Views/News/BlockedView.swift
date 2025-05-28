//
//  BlockedView.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 25.05.25.
//

import SwiftUI

struct BlockedView: View {
    @EnvironmentObject private var viewModel: NewsViewModel
    @State private var safariURL: IdentifiableURL?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Group {
            if viewModel.getBlocked().isEmpty {
                EmptyStateView(type: .noBlocked, action: nil)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.getBlocked()) { article in
                            ArticleRow(
                                article: article,
                                isFavorite: viewModel.isFavorite(article),
                                isBlocked: true,
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
        .navigationTitle("Blocked")
        .sheet(item: $viewModel.activeModal) { modal in
            if case .unblockConfirmation(let article) = modal {
                UnblockConfirmationView(article: article) {
                    viewModel.confirmUnblock(article)
                }
            }
        }
        .fullScreenCover(item: $safariURL) { SafariView(url: $0.url) }
    }
}

struct BlockedView_Previews: PreviewProvider {
    static var previews: some View {
        BlockedView()
            .environmentObject(NewsViewModel.preview)
    }
}
