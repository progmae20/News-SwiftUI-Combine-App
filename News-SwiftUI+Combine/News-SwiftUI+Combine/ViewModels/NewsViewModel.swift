//
//  NewsViewModel.swift
//  News-SwiftUI+Combine
//
//  Created by Anastasia on 22.05.25.
//

import SwiftUI
import Combine

class NewsViewModel: ObservableObject {
    
    // MARK: - Enums
    enum Tab: String, CaseIterable {
        case all = "All"
        case favorites = "Favorites"
        case blocked = "Blocked"
        
        var icon: String {
            switch self {
            case .all: return "newspaper"
            case .favorites: return "heart"
            case .blocked: return "slash.circle"
            }
        }
    }
    
    enum State {
        case idle
        case loading
        case loadingMore
        case loaded
        case error(String)
        
        var isLoading: Bool {
            if case .loading = self { return true }
            return false
        }
    }
    
    enum ModalType: Identifiable {
        case blockConfirmation(Article)
        case unblockConfirmation(Article)
        case startReading
        case premium
        case allNewsOverview
        
        var id: String {
            switch self {
            case .blockConfirmation(let article): return "block_\(article.id)"
            case .unblockConfirmation(let article): return "unblock_\(article.id)"
            case .startReading: return "start_reading"
            case .premium: return "premium"
            case .allNewsOverview: return "all_news_overview"
            }
        }
    }
    
    enum NewsError: LocalizedError {
        case noInternetConnection
        case timeout
        case unauthorized
        case clientError(Int)
        case serverError(Int)
        case invalidResponse
        case unknown
        case networkError(URLError)
        
        var errorDescription: String? {
            switch self {
            case .noInternetConnection: return "No internet connection"
            case .timeout: return "Request timed out"
            case .unauthorized: return "Authentication required"
            case .clientError(let code): return "Client error (\(code))"
            case .serverError(let code): return "Server error (\(code))"
            case .invalidResponse: return "Invalid server response"
            case .unknown: return "Unknown error occurred"
            case .networkError(let error): return error.localizedDescription
            }
        }
    }
    
    // MARK: - Published Properties
    @Published private(set) var articles: [Article] = []
    @Published private(set) var navigationBlocks: [NavigationBlock] = []
    @Published var selectedTab: Tab = .all
    @Published private(set) var state: State = .idle
    @Published var activeModal: ModalType? = nil
    
    // MARK: - Private Properties
    private var currentPage = 1
    private let pageSize = 10
    private var canLoadMore = true
    private var cancellables = Set<AnyCancellable>()
    private let newsService: NewsServiceProtocol
    private let navigationService: NavigationServiceProtocol
    private let storage: StorageServiceProtocol
    
    // MARK: - Initialization
    init(
        newsService: NewsServiceProtocol = NewsService(),
        navigationService: NavigationServiceProtocol = NavigationService(),
        storage: StorageServiceProtocol = StorageService.shared
    ) {
        self.newsService = newsService
        self.navigationService = navigationService
        self.storage = storage
        loadInitialData()
    }
    
    // MARK: - Public Methods
    
    func loadInitialData() {
        fetchNews()
        fetchNavigationBlocks()
    }
    
    func refresh() {
        currentPage = 1
        canLoadMore = true
        fetchNews()
    }
    
    func refreshAsync() async {
        await MainActor.run {
            refresh()
        }
    }
    
    func loadMoreIfNeeded(currentItem item: Article? = nil) {
        guard canLoadMore, !state.isLoading else { return }
        
        let thresholdIndex = articles.index(articles.endIndex, offsetBy: -5)
        if item == nil || articles.firstIndex(where: { $0.id == item?.id }) == thresholdIndex {
            currentPage += 1
            fetchNews()
        }
    }
    
    // MARK: - Navigation Blocks Handling
    func handleNavigationBlock(_ block: NavigationBlock) {
        switch block.navigationType {
        case "all_news":
            activeModal = .allNewsOverview
        case "modal":
            if block.title?.contains("Know What Matters") == true {
                activeModal = .startReading
            } else {
                activeModal = .premium
            }
        case "full_screen":
            activeModal = .premium
        default:
            break
        }
    }
    
    // MARK: - Article Management
    func getCurrentArticles() -> [Article] {
        switch selectedTab {
        case .all:
            return articles.filter { !isBlocked($0) }
        case .favorites:
            return getFavorites()
        case .blocked:
            return getBlocked()
        }
    }
    
    func openArticleInSafari(_ article: Article) -> IdentifiableURL? {
        guard let url = URL(string: article.webUrl) else { return nil }
        return IdentifiableURL(url: url)
    }
    
    // MARK: - Favorites Management
    func getFavorites() -> [Article] {
        storage.getFavorites()
    }
    
    func isFavorite(_ article: Article) -> Bool {
        storage.isFavorite(article)
    }
    
    func toggleFavorite(_ article: Article) {
        if isFavorite(article) {
            storage.removeFavorite(article)
        } else {
            storage.saveFavorite(article)
        }
        objectWillChange.send()
    }
    
    // MARK: - Block Management
    func getBlocked() -> [Article] {
        storage.getBlocked()
    }
    
    func isBlocked(_ article: Article) -> Bool {
        storage.isBlocked(article)
    }
    
    func showBlockConfirmation(for article: Article) {
        activeModal = isBlocked(article) ?
            .unblockConfirmation(article) :
            .blockConfirmation(article)
    }
    
    func confirmBlock(_ article: Article) {
        storage.blockArticle(article)
        if selectedTab == .all {
            articles.removeAll { $0.id == article.id }
        }
        activeModal = nil
    }
    
    func confirmUnblock(_ article: Article) {
        storage.unblockArticle(article)
        activeModal = nil
    }
    
    // MARK: - Private Methods
    private func fetchNews() {
        state = currentPage == 1 ? .loading : .loadingMore
        
        newsService.fetchNews(page: currentPage, pageSize: pageSize)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.state = .loaded
                case .failure(let error):
                    let errorMessage: String
                    if let newsError = error as? NewsError {
                        errorMessage = newsError.errorDescription ?? "Unknown error"
                    } else {
                        errorMessage = error.localizedDescription
                    }
                    self.state = .error(errorMessage)
                }
            } receiveValue: { [weak self] newArticles in
                guard let self = self else { return }
                
                if self.currentPage == 1 {
                    self.articles = newArticles
                } else {
                    self.articles.append(contentsOf: newArticles)
                }
                
                self.canLoadMore = newArticles.count >= self.pageSize
            }
            .store(in: &cancellables)
    }
    
    private func fetchNavigationBlocks() {
        navigationService.fetchNavigationBlocks()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Navigation blocks error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] blocks in
                self?.navigationBlocks = blocks
            }
            .store(in: &cancellables)
    }
}

// MARK: - Preview Extension
extension NewsViewModel {
    static var preview: NewsViewModel {
        let mockArticles = Article.previewData
        let mockBlocks = NavigationBlock.previewData
        
        let mockNewsService = MockNewsService(result: .success(mockArticles))
        let mockNavService = MockNavigationService(result: .success(mockBlocks))
        
        let vm = NewsViewModel(
            newsService: mockNewsService,
            navigationService: mockNavService,
            storage: StorageService.shared
        )
        vm.articles = mockArticles
        vm.navigationBlocks = mockBlocks
        return vm
    }
    
    static var errorState: NewsViewModel {
        let error = NSError(domain: "test", code: 500, userInfo: nil)
        let mockNewsService = MockNewsService(result: .failure(error))
        let mockNavService = MockNavigationService()
        
        return NewsViewModel(
            newsService: mockNewsService,
            navigationService: mockNavService,
            storage: StorageService.shared
        )
    }
    
    static var emptyState: NewsViewModel {
        let mockNewsService = MockNewsService(result: .success([]))
        let mockNavService = MockNavigationService()
        
        return NewsViewModel(
            newsService: mockNewsService,
            navigationService: mockNavService,
            storage: StorageService.shared
        )
    }
}
