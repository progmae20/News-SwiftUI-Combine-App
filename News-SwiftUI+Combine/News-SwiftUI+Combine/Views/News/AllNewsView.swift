//
//  AllNewsView.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 25.05.25.
//

import SwiftUI
import SafariServices

struct AllNewsView: View {
    @EnvironmentObject private var viewModel: NewsViewModel
    @State private var safariURL: IdentifiableURL?
    private let navigationBlockInterval = 2
    
    var body: some View {
        mainContentView
            .navigationTitle("News")
            .sheet(item: $viewModel.activeModal) { modal in
                modalContentView(for: modal)
            }
            .fullScreenCover(item: $safariURL) { SafariView(url: $0.url) }
    }
    
    @ViewBuilder
    private var mainContentView: some View {
        switch viewModel.state {
        case .idle:
            Color.clear
                .onAppear { viewModel.refresh() }
            
        case .loading:
            LoadingView()
            
        case .loadingMore:
            List {
                ForEach(viewModel.getCurrentArticles()) { article in
                    articleRow(for: article)
                }
                
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .onAppear { viewModel.loadMoreIfNeeded() }
            }
            
        case .loaded:
            if viewModel.getCurrentArticles().isEmpty {
                EmptyStateView(
                    type: .noNews,
                    action: { viewModel.refresh() }
                )
            } else {
                newsListView
            }
            
        case .error(let errorMessage):
            ErrorView(
                errorMessage: errorMessage,
                retryAction: { viewModel.refresh() }
            )
        }
    }
    
    private var newsListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(Array(viewModel.getCurrentArticles().enumerated()), id: \.element.id) { index, article in
                    VStack(spacing: 16) {
                        if shouldInsertNavigationBlock(after: index) {
                            navigationBlockView(for: index)
                        }
                        
                        articleRow(for: article)
                    }
                    .padding(.horizontal, 16)
                    .onAppear {
                        viewModel.loadMoreIfNeeded(currentItem: article)
                    }
                }
            }
            .padding(.top, 8)
        }
        .refreshable {
            await viewModel.refreshAsync()
        }
    }
    
    private func articleRow(for article: Article) -> some View {
        ArticleRow(
            article: article,
            isFavorite: viewModel.isFavorite(article),
            isBlocked: viewModel.isBlocked(article),
            favoriteAction: { viewModel.toggleFavorite(article) },
            blockAction: { viewModel.showBlockConfirmation(for: article) },
            tapAction: { safariURL = viewModel.openArticleInSafari(article) }
        )
    }
    
    @ViewBuilder
    private func modalContentView(for modal: NewsViewModel.ModalType) -> some View {
        switch modal {
        case .blockConfirmation(let article):
            BlockConfirmationView(
                article: article,
                confirmAction: { viewModel.confirmBlock(article) }
            )
        case .unblockConfirmation(let article):
            UnblockConfirmationView(
                article: article,
                confirmAction: { viewModel.confirmUnblock(article) }
            )
        case .startReading:
            StartReadingView()
        case .premium:
            PremiumView()
        case .allNewsOverview:
            AllNewsOverviewView()
        }
    }
    
    private func navigationBlockView(for index: Int) -> some View {
        let blockIndex = index / navigationBlockInterval - 1
        let block = viewModel.navigationBlocks[blockIndex]
        
        return NavigationBlockView(
            block: block,
            action: { viewModel.handleNavigationBlock(block) }
        )
    }
    
    private func shouldInsertNavigationBlock(after index: Int) -> Bool {
        index > 0 &&
        index % navigationBlockInterval == 0 &&
        (index / navigationBlockInterval - 1) < viewModel.navigationBlocks.count
    }
}

struct AllNewsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                AllNewsView()
                    .environmentObject(NewsViewModel.preview)
            }
            
            NavigationStack {
                AllNewsView()
                    .environmentObject(NewsViewModel.errorState)
            }
            
            NavigationStack {
                AllNewsView()
                    .environmentObject(NewsViewModel.emptyState)
            }
        }
    }
}
